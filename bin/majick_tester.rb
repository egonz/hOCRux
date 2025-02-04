#!/usr/bin/env ruby

# pull in our Rails 3.0 env
APP_PATH = File.expand_path('../../config/application',  __FILE__)
require File.expand_path('../../config/boot',  __FILE__)
require File.expand_path('../../config/environment',  __FILE__)

require 'json'
require 'majick_mirror'
require 'hocrux'

logger = Logger.new(STDOUT)
logger.formatter = Logger::Formatter.new
#49/131_L
json = '{"created_at":"2012-03-06T09:37:40Z","file_name":null,"id":19,"image":{"url":"/uploads/page/image/49/131_L.JPG","thumb":{"url":"/uploads/page/image/20/thumb_048_R.JPG"}},"page_number":null,"processed":null,"updated_at":"2012-03-06T09:37:40Z","user_book_id":8}'

page = JSON.parse(json)

mm = MajickMirror.new page['image']['url']
mm.process_image
mm.create_jpg_copy

hocrux = Hocrux.new mm.output_image_path
hocrux.hocr
hocrux.pdf
