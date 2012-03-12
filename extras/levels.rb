#convert 022_R.JPG -level 0,100,.46% -clamp +level 0,100% 022_R_LEVELS.JPG

require 'RMagick'
require 'fileutils'

include Magick

class Levels
  
  WORK_DIR = "work"
  OUT_DIR = "out"
  
  def initialize image, gamma
    @gamma = gamma
    
    #working files
    @input_image_file = image
    @file_name_sans_ext = "#{@input_image_file.chomp(File.extname(@input_image_file))}"
  end
  
  def convert
    magick = "convert #{@input_image_file} -level 0,100,.#{@gamma}% -clamp +level 0,100% #{@input_image_file}"
    
    puts magick
    system magick
  end  
  
end

