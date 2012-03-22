class EdocsController < ApplicationController
	before_filter :authenticate_user!

	def show
		edoc_id = params[:id]
		logger.info "Edoc ID #{edoc_id}"
		@edoc = Edoc.find(edoc_id)
	end

end
