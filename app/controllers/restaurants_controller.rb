class RestaurantsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @restaurants = Restaurant.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    begin
      @restaurant = Restaurant.find(params[:id])
      @comments = Comment.where restaurant_id: params[:id]
      @comment = Comment.new
    rescue
      p "Being rescued"
      redirect_to restaurants_path
    end
  end
  
  def new
    if !current_user then redirect_to root_path end
    @user = current_user
    @restaurant = Restaurant.new
  end

  def edit
    @restaurant = Restaurant.find params[:id]
  end

  def update
    restaurant = Restaurant.find params[:id]
    
    # The following line will reset all of the votes that a wait time has.
    # The idea is that Users are voting on the wait time that has been
    # posted and not the quality of the Restaurant itself.
    restaurant.votes_for.destroy_all

    restaurant.update name: restaurant_params[:name], wait: restaurant_params[:wait] if restaurant_params
    redirect_to restaurant
  end

  def create
    @restaurant = Restaurant.new restaurant_params
    @restaurant.update user_id: current_user.id
    if @restaurant.save
      redirect_to root_path
    # Check for existence in database
    elsif Restaurant.exists? unique_name: @restaurant.name.downcase
      flash[:danger] = "That restaurant already exists in the database. Please update the wait time for this restaurant if you have the permission to or vote on the current wait time."
      redirect_to Restaurant.find_by unique_name: @restaurant.name.downcase
    elsif @restaurant.wait < 0
      flash[:danger] = "You can't post a restaurant with a negative wait time."
      redirect_to new_restaurant_path
    else
      flash[:danger] = "Uh oh, something went wrong. Try and make another restaurant!"
      redirect_to new_restaurant_path
    end
  end

  def destroy
    Restaurant.find(params[:id]).destroy
    redirect_to restaurants_path
  end
 
  # Handle upvotes
  def upvote
    @restaurant = Restaurant.find params[:id]
    current_user.likes @restaurant
    # Now update the reputation of the person that posted the most recent update to the Restaurant
    User.find(@restaurant.user_id).increment!(:reputation, 1)
    if request.xhr?
      render json: { upvote: true, count: @restaurant.get_upvotes.size, id: params[:id] }
    else
      redirect_to @restaurant
    end
  end
  
  # Handle downvotes
  def downvote
    @restaurant = Restaurant.find params[:id]
    current_user.dislikes @restaurant
    # Now update (by decrementing) the reputation of the user who most recently updated the wait time
    User.find(@restaurant.user_id).decrement!(:reputation, 1)
    if request.xhr?
      render json: { upvote: false, count: @restaurant.get_downvotes.size, id: params[:id] }
    else
      redirect_to @restaurant
    end
  end

  # Private methods below
  private
    def restaurant_params
      params.require(:restaurant).permit(:name, :wait, :address, :city, :state, :zip, :lat, :lng)
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
