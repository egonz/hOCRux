class Page < ActiveRecord::Base
	belongs_to :user_book

  mount_uploader :image, PageUploader

	before_create do |page|
    prev_last_page = Page.where(:user_book_id=>page.user_book.id).last

		if prev_last_page.nil?
			page.page_no = 1
		else
			page.page_no = prev_last_page.page_no + 1
		end
  end

	def publish_to_mq
		client = OnStomp::Client.new("stomp://127.0.0.1:61613")
		client.connect
		client.send('/queue/imagescans', self.to_json.to_s)
		client.disconnect
	end

	def all_pages_processed?
		total_pages_processed = Page.where("user_book_id=? AND processed=true AND pdf_file is not null",  self.user_book.id ).count

		self.user_book.total_pages == total_pages_processed
	end

	def self.set_last_page user_book_id
		old_last_pages = Page.where(:user_book_id=>user_book_id, :last_page=>true)

		old_last_pages.each do |old_last_page|
			old_last_page.last_page=false
			old_last_page.save
		end

		page = Page.where(:user_book_id=>user_book_id).last
		page.last_page=true
		page.save
	end
end
