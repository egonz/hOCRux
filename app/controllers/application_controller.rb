class ApplicationController < ActionController::Base
  protect_from_forgery
	before_filter :validate_user


	private

	def validate_user
		if user_signed_in?
			@user = current_user
		end
	end

end
