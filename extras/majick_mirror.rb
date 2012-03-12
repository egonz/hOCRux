#!/usr/bin/env ruby

#########################################################
# This script provides ImageMagick proccessing suitable #
# for a scanned image of text.                          #
#                                                       #
# This script assumes that images will be placed in the #
# public folder.                                        #
#########################################################

require File.expand_path('../../config/boot',  __FILE__)
require File.expand_path('../../config/environment',  __FILE__)
require 'RMagick'
require 'fileutils'
require '/home/egonz/projects/Majick12/extras/text_cleaner.rb'
require '/home/egonz/projects/Majick12/extras/levels.rb'

include Magick


class MajickMirror

	attr_accessor :output_image_path

  def initialize(image, text_image=true)
		@text_image = text_image
		@work_dir = File.expand_path('../..',  __FILE__) + "/tmp"
		@public_dir = File.expand_path('../..',  __FILE__) + "/public"
  	@out_dir = @public_dir + File.dirname(image)
    @input_image_file = File.basename image
    @file_name_sans_ext = "#{@input_image_file.chomp(File.extname(@input_image_file))}"
    @tmp_image_file = "#{@work_dir}/#{@file_name_sans_ext}.mpc"

		@logger = Logger.new(STDOUT)
		@logger.formatter = Logger::Formatter.new
  end

	def process_image
    remove_temp_files
    create_temp_copy

    beginning_time = Time.now

    if @text_image
      process_text_page
    end

    post_process

    #save the image
  	@working_image = @working_image.write "#{@tmp_image_file}"

  	remove_temp_files

  	end_time = Time.now
    @logger.debug "Time elapsed #{(end_time - beginning_time)*1000} miliseconds"
	end

  def create_jpg_copy
		@output_image_path = "#{@out_dir}/#{@file_name_sans_ext}_mj12.JPG"
    @working_image.format = "JPEG"
    @working_image.density = "150x150"
    @working_image.compression = Magick::NoCompression
    @logger.info "save image #{@output_image_path}"
    @working_image.write @output_image_path
  end

  private

  def process_text_page
  	#Clean the image
  	tc = TextCleaner.new( @tmp_image_file, 15, 5 )
    tc.clean

  	#Adjust the gamma levels
    l = Levels.new( @tmp_image_file, 96 )
    l.convert

  	#Deskew
  	@working_image = @working_image.deskew(0.40)
  end

  def post_process
    #Resize width to iPad resolution
		#@working_image.resize! 768, @working_image.rows

		#Resize height to iPad resolution
	  #@working_image.resize! @working_image.columns, 1024

		#Extend the image so that the canvas is 1024x768
		@working_image.gravity = Magick::CenterGravity
		@working_image.extent 768, 1024
  end

  def remove_temp_files
    FileUtils.rm_f "#{@tmp_image_file}"
    FileUtils.rm_f "#{@work_dir}/#{@file_name_sans_ext}.cache"
  end

  def create_temp_copy
    @logger.info "Processing #{@out_dir}/#{@input_image_file} ..."
    @working_image = ImageList.new("#{@out_dir}/#{@input_image_file}")
    @logger.info "writing #{@tmp_image_file}"
    @working_image.write "#{@tmp_image_file}"
  end

end
