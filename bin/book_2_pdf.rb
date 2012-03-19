#!/usr/bin/env ruby
#
# Dequeue a UserBook, select all its Pages, and generate a single PDF
#

# pull in our Rails 3.0 env
APP_PATH = File.expand_path('../../config/application',  __FILE__)
require File.expand_path('../../config/boot',  __FILE__)
require File.expand_path('../../config/environment',  __FILE__)

require 'json'
require 'hocrux'

logger = Logger.new(STDOUT)
logger.formatter = Logger::Formatter.new

# Set up our exit flag for a clean shutdown
exit_requested = false

Signal.trap('INT') { exit_requested = true }
Signal.trap('TERM') { exit_requested = true }

client = OnStomp::Client.new("stomp://127.0.0.1:61613")
client.connect

logger.info("connected")

client.subscribe("/queue/book2pdf", :ack=>'client') do |m|
	body = m.body

	logger.info "JSON Message: #{m.inspect}"
	logger.info "Processing Message: #{body}"

	begin
		# => parse basic info
		timestamp = Time.at(m.headers[:timestamp].to_i/1000)   # it's in milliseconds

 		page = JSON.parse(body)

		if (!exit_requested)
			ub = UserBook.find page["id"]

			hocrux = Hocrux.new
			hocrux.single_pdf ub.pages, ub.book.title

			edoc = create_edoc(ub, hocrux.pdf_file)
			send_email edoc

			logger.info "Finished creating a single PDF #{hocrux.single_pdf_file}"
		end

		client.ack m

 	rescue => e
   	logger.error("Error in handling queued book2pdf message  [e=#{e}].")
		logger.error(e.backtrace.join("\n"))
	end
end

def create_edoc ub, pdf_file
	edoc = Edoc.new
	edoc.user_book=ub
	edoc.file_name=pdf_file
	edoc.doc_type='PDF'
	edoc.save
	edoc
end

def send_email edoc
	HocruxMailer.pdf_conversion_completed(edoc).deliver
end

loop do
 sleep(10)
end while !exit_requested

client.disconnect
