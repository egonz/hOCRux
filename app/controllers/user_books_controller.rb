class UserBooksController < ApplicationController
	before_filter :authenticate_user!

	def index
		@user_books = UserBook.where(:user_id=>current_user.id)
	end

	def show
    @user_book = UserBook.find(params[:id])
  end

	def new

	end

	def create
		title = params[:title]
		isbn = params[:isbn]
		auto_gen_pdf = params[:auto_gen_pdf]
		email_doc = params[:email_doc]

		puts "Creating book for #{current_user.inspect}"
		@user_book = UserBook.create_book title, isbn, current_user, auto_gen_pdf, email_doc
		puts "New Book #{@user_book.inspect}"

		render :action=>:show
	end

	def destroy
		#TODO move this into the UserBook model
		user_book = UserBook.find(params[:id])
		user_book.delete

		redirect_to user_books_url
	end

end
