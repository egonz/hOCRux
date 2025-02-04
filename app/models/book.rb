class Book < ActiveRecord::Base

	def self.find_book title, isbn
		Book.where("title = :title OR isbn <= :isbn", {:title => title, :isbn => isbn}).limit(1).first
	end

end
