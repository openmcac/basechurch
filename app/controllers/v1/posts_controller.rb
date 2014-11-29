class V1::PostsController < ApplicationController
  serialization_scope nil

  before_action :authenticate_user!, except: [:show]
  before_action :set_group
  before_action :set_post, only: [:create]

  attr_reader :post

  def show
    post = Post.find(params['id'])
    render json: post
  end

  def create
    begin
      post.save!
      render json: post.reload
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.to_s }, status: :unprocessable_entity
    end
  end

  private
  def set_post
    @post = Post.new
    @post.content = user_params[:content]
    @post.title = user_params[:title]
    @post.display_published_at = user_params[:publishedAt]
    @post.group = @group
    @post.author = current_user
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def user_params
    params.require(:post)
  end
end
