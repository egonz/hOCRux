#!/usr/bin/env ruby
#
# Dequeue an image scan to be majickd, majick it, and insert the result in the db
#

# pull in our Rails 3.0 env
APP_PATH = File.expand_path('../../config/application',  __FILE__)
require File.expand_path('../../config/boot',  __FILE__)
require File.expand_path('../../config/environment',  __FILE__)

require 'json'
require 'majick_mirror'

logger = Logger.new(STDOUT)
logger.formatter = Logger::Formatter.new

# Set up our exit flag for a clean shutdown
exit_requested = false

Signal.trap('INT') { exit_requested = true }
Signal.trap('TERM') { exit_requested = true }

client = OnStomp::Client.new("stomp://127.0.0.1:61613")
client.connect

logger.info("connected")

client.subscribe("/queue/imagescans", :ack=>'client') do |m|
	body = m.body

	logger.info "Processing Message: #{body}"

	begin
		# => parse basic info
		timestamp = Time.at(m.headers[:timestamp].to_i/1000)   # it's in milliseconds

 		page = JSON.parse(body)
		p = Page.find page["id"]

		if (!exit_requested)
			mm = MajickMirror.new(p.image.to_s, p.user_book.width, p.user_book.height)
			mm.process_image
			mm.create_jpg_copy

			if File.exist? mm.output_image_path
				if p.user_book.auto_gen_pdf?
					logger.debug "Performing OCR and generating PDF"
					hocrux = Hocrux.new mm.output_image_path
					hocrux.hocr
					hocrux.pdf

					logger.info "Processed PDF For #{mm.output_image_path}"

					p.processed=true
					p.processed_image=mm.output_image_path
					p.pdf_file = hocrux.pdf_file
					p.save

					logger.debug "Saved Page Data"

					if p.all_pages_processed?
						logger.info "Finished Processing Pages For #{p.user_book.book.title}"
						p.user_book.publish_to_mq
					end
				else
					p.processed=true
					p.processed_image=mm.output_image_path
					p.save

					HocruxMailer.imgage_processing_completed(p.user_book).deliver
				end
			end

			client.ack m
		end

 	rescue => e
   	logger.error("Error in handling queued majick message  [e=#{e}].")
		logger.error(e.backtrace.join("\n"))
	end
end

loop do
 sleep(10)
end while !exit_requested

client.disconnect
