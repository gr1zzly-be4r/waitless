class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction

  def new
    @user = User.new
  end
  
  def show
    if !logged_in? || current_user.id != params[:id].to_i
      flash[:danger] = "You're not authorized to access this page."
      redirect_to root_path
    end
    @user = User.find params[:id]
    @restaurants = Restaurant.order(sort_column + " " + sort_direction).where(user_id: @user.id).paginate(:page => params[:page], :per_page => 10)
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = "Thanks for signing up for Waitlist!"
      log_in @user
      redirect_to @user
    else
      flash[:danger] = "Uh oh, something went wrong. Please read the error messages and try again."
      render 'new'
    end
  end

  # Settings
  def settings
    if !logged_in? || current_user.id != params[:id].to_i
      flash[:danger] = "You're not authorized to view this page."
      redirect_to root_path
    end
    @user = User.find params[:id]
  end

  # User can view their own comments
  def comments
    if current_user.nil? then redirect_to root_path end
    # SQL query to find all of the restaurants that the current user has 
    # made a comment on.
    @restaurants = Restaurant.find_by_sql "SELECT restaurants.id, name FROM restaurants JOIN comments ON (comments.restaurant_id = restaurants.id AND comments.user_id = #{params[:id]}) GROUP BY restaurants.name, restaurants.id"
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end

    # Helper method for dynamic sorting of restaurants. Default sorting method is by name of the Restaurant.
    def sort_column
      Restaurant.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    # Helper method for dynamic sorting of restaurants.
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
    
end

