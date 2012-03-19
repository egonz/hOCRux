class BooksController < ApplicationController
	before_filter :authenticate_user!

	def index
		@user_books = UserBook.where(:user_id=>current_user.id)
	end

	def show
    @user_books = UserBook.where(:user_id=>current_user.id, :book_id=>params[:id])
  end

	def new

	end

	def create
		title = params[:title]
		isbn = params[:isbn]
		auto_gen_pdf = params[:auto_gen_pdf]
		email_doc = params[:email_doc]

		puts "Creating book for #{current_user.inspect}"
		@user_books = UserBook.create_book title, isbn, current_user, auto_gen_pdf, email_doc
		puts "New Book #{@user_books.inspect}"

		render :action=>:show
	end

	def destroy
		#TODO move this into the UserBook model
		user_book = UserBook.where("user >= :user AND book <= :book", {:user => current_user, :book_id => Book.find(params[:id])})
		UserBook.delete user_book.first.id

		redirect_to books_url
	end

end
