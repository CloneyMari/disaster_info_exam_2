class PostsController < ApplicationController
before_action :authenticate_user!, except: [:index, :show]
before_action :set_post, only: [:show, :edit, :update, :destroy]
require 'csv'

  def index
    @posts = Post.includes(:categories, :user).page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [
           'code', 'name', 'region_code', 'province_code', 'city_code'
          ]
          
          Address::Region.all.each do |region|
            csv << [
             region.code, region.name
            ]
          end
          Address::Province.includes(:region).all.each do |province|
            csv << [
             province.code, province.name, province.region.code
            ]
          end
          Address::City.includes(:province).all.each do |city|
            csv << [
             city.code, city.name, nil, city.province.code
            ]
          end
          Address::Barangay.includes(:city).all.each do |barangay|
            csv << [
             barangay.code, barangay.name, nil, nil, barangay.city.code
            ]
          end
        end
        render plain: csv_string
      }
    end
  end

  def new
    @post = Post.new
  end

  def create
   @post = Post.new(post_params)
   @post.user = current_user
   if Rails.env.development?
      @post.ip_address = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
    else
      @post.ip_address = request.remote_ip
    end
    if @post.save
      flash[:notice] = 'Post created successfully'
      redirect_to posts_path
    else
      flash.now[:alert] = 'Post create failed'
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit
    authorize @post, :edit?, policy_class: PostPolicy
   end

  def update
   authorize @post, :update?, policy_class: PostPolicy
   if @post.update(post_params)
      flash[:notice] = 'Post updated successfully'
      redirect_to posts_path
    else
      flash.now[:alert] = 'Post update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post, :destroy?, policy_class: PostPolicy
    @post.destroy
    flash[:notice] = 'Post destroyed successfully'
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :image, :address, :address_region_id, :address_province_id, :address_city_id, :address_barangay_id, category_ids: [])
  end
end