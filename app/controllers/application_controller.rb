class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :current_user
  protect_from_forgery

  protected
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
    if request[:key] and not @current_user
      k = ApiKey.find_by_value request[:key]
      @current_user = k.user if k and k.user
    end

    @current_user
  end

  def signed_in?
    !!current_user
  end

  def must_be_user
    unless current_user
      flash[:notice] = "You must be logged in to do that."
      redirect_to about_url 
    end
  end

  helper_method :current_user, :signed_in?

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
  end

  def logout
    @current_user = nil
    session[:user_id] = nil
  end
end
