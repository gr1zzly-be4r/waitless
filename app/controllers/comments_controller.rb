class CommentsController < ApplicationController

  def create
    @comment = Comment.new comment_params
    restaurant = Restaurant.find comment_params[:restaurant_id]
    if @comment.save
      flash[:success] = "Comment created."
      redirect_to restaurant_path restaurant 
    else
      flash[:danger] = "Something went wrong."
      redirect_to restaurant
    end
  end

  def edit
    @comment = Comment.find params[:id]
    if !logged_in? || current_user.id != @comment.user_id
      flash[:danger] = "You can't edit a comment that you didn't post yourself."
      redirect_to comment_path(@comment)
    end
  end

  def show
    @comment = Comment.find params[:id]
  end

  def update
    @comment = Comment.find params[:id]
    if !logged_in? then redirect_to comment_path(@comment) end
    @comment.update content: params[:comment][:content]
    redirect_to comment_path @comment
  end


  # Private methods below
  private
    def comment_params
      params.require(:comment).permit(:content, :user_id, :restaurant_id)
    end

end

