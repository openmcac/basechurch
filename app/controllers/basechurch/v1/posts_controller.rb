class Basechurch::V1::PostsController < Basechurch::ApplicationController
  serialization_scope nil

  before_action :authenticate_user!, except: [:show]
  before_action :set_group, except: [:show]

  attr_reader :post

  def show
    post = Basechurch::Post.find(params['id'])
    render json: post
  end

  def create
    @post = Basechurch::Post.new
    set_post_with_params(@post)
    save_post_and_render
  end

  def update
    @post = Basechurch::Post.find(params['id'])
    @post.editor = current_user
    set_post_with_params(@post)
    save_post_and_render
  end

  private
  def save_post_and_render
    begin
      post.save!
      render json: post.reload
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.to_s }, status: :unprocessable_entity
    end
  end

  def set_post_with_params(post)
    post.content = user_params[:content]
    post.title = user_params[:title]
    post.display_published_at = user_params[:publishedAt]
    post.group = @group
    post.author ||= current_user
    post.tag_list = user_params[:tags]
  end

  def set_group
    @group = Basechurch::Group.find(user_params[:group_id])
  end

  def user_params
    params.require(:post)
  end
end
