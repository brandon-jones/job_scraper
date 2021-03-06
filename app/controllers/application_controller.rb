class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def authenticated
    unless current_user
      flash[:notice] = "You need to log in to visit that page"
      redirect_to root_path
    end
  end
  helper_method :authenticated?

  def authenticated_admin?
    unless current_user && current_user.admin?
      flash[:notice] = "You must be an admin to visit that page"
      redirect_to root_path
    end
  end
  helper_method :authenticated_admin?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password) 
    }
  end
end
