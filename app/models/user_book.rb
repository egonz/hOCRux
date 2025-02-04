require 'digest'

class UserBook < ActiveRecord::Base
	belongs_to :user
	belongs_to :book
	belongs_to :library
	has_many :pages,  :dependent => :destroy
	has_many :edocs,  :dependent => :destroy

	before_create do |page|
    create_book_hash_key page
  end

	def publish_to_mq
		client = OnStomp::Client.new("stomp://127.0.0.1:61613")
		client.connect
		client.send('/queue/book2pdf', self.to_json.to_s)
		client.disconnect
	end

	def add_pages new_pages_count
		old_page_count = self.total_pages.nil? ? 0 : self.total_pages
		puts "Old Page Count #{old_page_count} New Page Count #{new_pages_count}"
		self.total_pages = old_page_count + new_pages_count.to_i
		self.save
	end

	def publish_pages
		set_max_width_height

		self.pages.order('page_no asc').each do |page|
			page.publish_to_mq
		end
	end

	def publish_unprocessed_pages
                set_max_width_height

                self.pages.where(:processed_image=>nil).order('page_no asc').each do |page|
			logger.info "Processing Unprocessed Page ID: #{page.id}"
                        page.publish_to_mq
                end
        end

	def self.create_book title, isbn, user, auto_gen_pdf, email_doc
		logger.info "Searching for Book Title #{title} OR ISBN #{isbn}..."
		book = Book.find_book title, isbn

		logger.debug "Retreived Book #{book.inspect}" unless book.nil?

		if book.nil?
			book = Book.new  :title=>title, :isbn=>isbn
		end

		@user_book = UserBook.new :book=>book, :user=>user,
			:auto_gen_pdf=>auto_gen_pdf, :email_doc=>email_doc
		@user_book.save
		@user_book
	end

	private

	def set_max_width_height
		self.width = Page.maximum(:width, :conditions=>["user_book_id=?", self.id])
   	self.height = Page.maximum(:height, :conditions=>["user_book_id=?", self.id])

		self.save
	end

	def create_book_hash_key page
		page.hash_key = Digest::MD5.hexdigest(Time.new.to_s)
	end

end
