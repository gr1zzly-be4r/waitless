class SessionsController < ApplicationController
  def new
  end

  def create
    # User information is going to be stored in params[:session]
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = "Login successful!"
      redirect_to user 
    else
      flash[:danger] = "Uh oh, something went wrong. Please try to log in again."
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = "You've been successfully logged out."
    redirect_to root_path
  end


end

