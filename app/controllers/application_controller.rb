class ApplicationController < ActionController::Base

	before_action :configure_permitted_parameters, if: :devise_controller?

	protected

	def configure_permitted_parameters
		attributes = [:first_name, :last_name, :email, :phone, :avatar]
		devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
		devise_parameter_sanitizer.permit(:account_update, keys: attributes)

	end

	

	Paperclip.options[:content_type_mappings] = {
		:pem => "text/plain"
	}


end

