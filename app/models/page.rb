require 'RMagick'
require 'fileutils'

class Page < ActiveRecord::Base
	belongs_to :user_book

  mount_uploader :image, PageUploader

	before_create do |page|
    set_page_no page
		set_width_height page
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

	def processed_image_thumb_url
		unless self.processed_image.nil?
			return "#{image_dir}/thumb_#{processed_image_file_name}"
		else
			return ""
		end
	end

	def image_dir
		File.dirname(self.processed_image)
	end

	def processed_image_file_name
		File.basename(self.processed_image)
	end

	private

	def set_page_no page
		prev_last_page = Page.where(:user_book_id=>page.user_book.id).last

		if prev_last_page.nil?
			page.page_no = 1
		else
			page.page_no = prev_last_page.page_no + 1
		end
	end

	def set_width_height page
		page_img_path = "#{Rails.root.to_s}/public#{page.image}"
		logger.debug "Getting width and height for #{page_img_path}"
		page_img = Magick::ImageList.new(page_img_path)
		page.width = page_img.columns
		page.height = page_img.rows
	end
end
