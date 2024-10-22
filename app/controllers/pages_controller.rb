class PagesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_user_book
  before_filter :find_or_build_page, :except => ['last_page']

  def index
  end

  def new

  end

  def show

  end

  def replace
    unless @page.nil?
	@page.remove_dir
    	@page.image = params[:Filedata]
	@page.processed_image=nil
    	@page.save

	@page.publish_to_mq
    end

    render :text=>@page.image_url
  end

  def processed
	if @page.processing_completed?
		render :text=>'true'
	else
		render :text=>'false'	
	end
  end

  def create
    logger.debug "UserBook: #{@user_book.inspect}"
    logger.debug "Page: #{@page.inspect}"

    unless @page.save
      logger.error "Error uploading photo"
      flash[:error] = 'Photo could not be uploaded'
    end

    render :text => render_to_string(:partial => 'pages/page', :locals => {:page => @page})
  end

  def last_page
    total_pages = params['total_pages']
    @user_book.add_pages total_pages
		@user_book.publish_pages

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
