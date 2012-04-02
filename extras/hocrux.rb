require 'fileutils'

class Hocrux

  attr_accessor :pdf_file

  def initialize image=nil
		@public_dir = File.expand_path('../..',  __FILE__) + "/public"

		unless image == nil
			@input_image = image
			@input_image_full_path = "#{@public_dir}#{@input_image}"
    	@file_name_sans_ext = "#{@public_dir}#{@input_image.chomp(File.extname(@input_image))}"
		end

		@logger = Logger.new(STDOUT)
		@logger.formatter = Logger::Formatter.new
  end

  def hocr
    tesseract = "tesseract #{@input_image_full_path} #{@file_name_sans_ext} -l en hocr"
    @logger.debug tesseract
    system tesseract
  end

	def pdf
		hocr2pdf = "hocr2pdf -i #{@input_image_full_path} -o #{@file_name_sans_ext}.pdf < #{@file_name_sans_ext}.html"
		@logger.debug hocr2pdf
		@pdf_file = "#{@file_name_sans_ext}.pdf"
		system hocr2pdf
	end

	def single_pdf pages, pdf_file
		# combine the pages into one PDF
		@pdf_file_name = pdf_file.gsub(' ','_')
		@work_dir = File.expand_path('../..',  __FILE__) + "/tmp/#{@pdf_file_name}/"
		hash_key = pages.first.user_book.hash_key
		@single_pdf_dir = File.expand_path('../..',  __FILE__) + "/public/user/books/#{hash_key}/#{@pdf_file_name}"
		@single_pdf_file = "#{@single_pdf_dir}/#{@pdf_file_name}.pdf"

		pages.each do |page|
			create_temp_copy page.pdf_file
		end

		create_out_dir

		ghost_in_the_machine = "gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=#{@single_pdf_file} #{@work_dir}*.pdf"
		@logger.debug ghost_in_the_machine
		system ghost_in_the_machine

		rm_temp_files

		@pdf_file = "/user/books/#{hash_key}/#{@pdf_file_name}/#{@pdf_file_name}.pdf"
	end

	private

	def create_temp_copy pdf_file
		@logger.info "copying #{pdf_file} to #{@work_dir}"

		unless File.exist? @work_dir
			FileUtils.mkdir @work_dir
		end

    FileUtils.cp pdf_file, @work_dir
  end

	def create_out_dir
		unless File.exist? @single_pdf_dir
			FileUtils.mkdir_p @single_pdf_dir
		end
	end

	def rm_temp_files
		unless File.exist? @work_dir
			FileUtils.remove_dir @work_dir
		end
	end

end
