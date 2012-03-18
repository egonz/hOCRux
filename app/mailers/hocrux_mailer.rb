class HocruxMailer < ActionMailer::Base
  default from: "hocruxbeta@gmail.com"

	def imgage_processing_completed user_book
		@user_book = user_book
		mail(:to=>user_book.user.email)
	end

	def pdf_conversion_completed edoc
		@edoc = edoc
		mail(:to=>edoc.user_book.user.email)
	end
end
