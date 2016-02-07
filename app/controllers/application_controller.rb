# encoding: UTF-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :signed_restriction, :unless => :devise_controller?, :only => [:new, :create]

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  # PERMIT
  # ============================================================
  # Membership
  # ------------------------------------------------------------
  def signed_restriction
    unless user_signed_in?
      redirect_to root_url
    end
  end

  def admin_restriction
    unless current_user.admin?
      redirect_to root_url
    end
  end

  # Model
  # ------------------------------------------------------------
  def can_destroy?(model)
    unless model.destroyable? current_user
      redirect_to model     
    end
  end

  def can_edit?(model)
    unless model.editable? current_user
      redirect_to model     
    end
  end

  def can_view?(model, redirection = root_url)
    unless model.viewable? current_user
      redirect_to redirection     
    end
  end

end
