class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  #->Prelang (user_login:devise)
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user|
      user.permit(:username, :email, :password, :password_confirmation, :remember_me, :address_id, address_attributes: [:address1, :address2, :city, :state, :zip, :id])
    end
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :email, :password, :password_confirmation, :remember_me, :address_id, address_attributes: [:address1, :address2, :city, :state, :zip, :id]])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation, :remember_me,:address_id, address_attributes: [:address1, :address2, :city, :state, :zip, :id]])
  end


  private
  
  #-> Prelang (user_login:devise)
  def require_user_signed_in
    unless user_signed_in?

      # If the user came from a page, we can send them back.  Otherwise, send
      # them to the root path.
      if request.env['HTTP_REFERER']
        fallback_redirect = :back
      elsif defined?(root_path)
        fallback_redirect = root_path
      else
        fallback_redirect = "/"
      end

      redirect_to fallback_redirect, flash: {error: "You must be signed in to view this page."}
    end
  end

end
