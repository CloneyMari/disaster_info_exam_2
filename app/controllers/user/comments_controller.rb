class User::CommentsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :validate_comment_owner, only: [:edit, :update, :destroy]

  def index
    @comments = current_user.comments.includes(:user).page(params[:page]).per(5)
  end
 
  def edit; end

  def update
    if @comment.update(comment_params)
     flash[:notice] = 'Comment updated successfully'
     redirect_to post_comments_path(@post)
    else
     render :edit
   end
 end

 def destroy
    @comment.destroy
    flash[:notice] = 'Comment deleted successfully'
    redirect_to post_comments_path(@post)
 end
  

 private

  def comment_params
   params.require(:comment).permit(:content)
  end

 def set_comment
   @comment = current_user.comments.find(params[:id])
 end

  def validate_comment_owner
   unless @comment.user == current_user
     flash[:notice] = 'the comment not belongs to you'
     redirect_to post_comments_path(@post)
   end
 end
end