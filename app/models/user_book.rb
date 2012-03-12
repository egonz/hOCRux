class UserBook < ActiveRecord::Base
	belongs_to :user
	belongs_to :book
	belongs_to :library
	has_many :pages,  :dependent => :destroy

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

end
