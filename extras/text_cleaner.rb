require 'RMagick'
require 'fileutils'

include Magick

class TextCleaner

  WORK_DIR = "work"
  OUT_DIR = "out"

  def initialize image, filtersize, offset
    @filtersize = filtersize
    @offset = offset

    #todo if image is not an mpc file, create one

    #working files
    @input_image_file = image
    @file_name_sans_ext = "#{@input_image_file.chomp(File.extname(@input_image_file))}"
  end

  def clean
    magick = "convert -respect-parenthesis \\( #{@input_image_file} -colorspace gray -type grayscale -normalize \\) \\
	\\( -clone 0  -colorspace gray -negate -lat #{@filtersize}x#{@filtersize}+#{@offset}% -contrast-stretch 0 \\) \\
	-compose copy_opacity -composite -fill 'white' -opaque none +matte \\
	#{@input_image_file}"

	#-sharpen 0x1 \\

    puts magick
    system magick
  end

end
