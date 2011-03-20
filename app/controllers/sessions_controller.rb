class SessionsController < ApplicationController
  def create
    auth = request.env['rack.auth']
    @auth = Authorization.find_from_hash(auth)
    unless @auth
      # Create a new user or add an auth to existing user, depending on
      # whether there is already a user signed in.
      @auth = Authorization.create_from_hash(auth, current_user)
    end
    # Log the authorizing user in.
    self.current_user = @auth.user

    flash[:notice] = "Welcome, #{current_user.name}"
    do_redirect
  end

  def destroy
    self.logout
    flash[:notice] = "You are logged out."
    do_redirect
  end

  def twitter
    session[:redirect_target] = request.referer unless session[:redirect_target]
    redirect_to :controller => :auth, :action => :twitter
  end

  private
  def do_redirect
    if session[:redirect_target]
      redirect_to session[:redirect_target]
      session[:redirect_target] = nil
    else
      redirect_to :controller => :home, :action => :index
    end
  end
end
