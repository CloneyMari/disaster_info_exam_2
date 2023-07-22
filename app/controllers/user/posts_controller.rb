class User::PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    
      def index
        @posts = current_user.posts.includes(:categories, :user).page(params[:page]).per(5)
      end
    
      def show; end
    
      def edit; end
    
      def update
       if @post.update(post_params)
          flash[:notice] = 'Post updated successfully'
          redirect_to posts_path
        else
          flash.now[:alert] = 'Post update failed'
          render :edit, status: :unprocessable_entity
        end
      end
    
      def destroy
        @post.destroy
        flash[:notice] = 'Post destroyed successfully'
        redirect_to posts_path
      end
    
     private
    
     def validate_post_owner
       unless @post.user == current_user
         flash[:notice] = 'the post not belongs to you'
         redirect_to posts_path
       end
     end
    
      def set_post
        @post = Post.first
      end
    
      def post_params
        params.require(:post).permit(:title, :content, :image, :address, :address_region_id, :address_province_id, :address_city_id, :address_barangay_id, category_ids: [])
      end
    end