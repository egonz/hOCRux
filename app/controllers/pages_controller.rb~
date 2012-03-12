class PagesController < ApplicationController

	before_filter :authenticate_user!
	before_filter :find_user_book
  before_filter :find_or_build_page

	def new

	end

	def show

	end

  def create
		logger.info "UserBook: #{@user_book}"
		logger.info "Page: #{@page}"

  	respond_to do |format|
      unless @page.save
        flash[:error] = 'Photo could not be uploaded'
      end

			#Publish to MQ for ImageMagick processing
			@page.publish_to_mq

      format.js do
        render :text => render_to_string(:partial => 'pages/page', :locals => {:page => @page})
      end
    end
  end

	def last_page
		total_pages = params['total_pages']
		@user_book.add_pages total_pages

		render :text=>"OK"
	end

  def destroy
    respond_to do |format|
      unless @page.destroy
        flash[:error] = 'Page could not be deleted'
      end
      format.js
    end
  end

  private

    def find_user_book
			@user_book = current_user.user_books.find(params[:book_id])
      raise ActiveRecord::RecordNotFound unless @user_book
    end

    def find_or_build_page
      @page = params[:id] ? @user_book.pages.find(params[:id]) : @user_book.pages.build(:image => params[:Filedata])
    end

end
