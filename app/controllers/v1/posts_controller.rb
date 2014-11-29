class V1::PostsController < ApplicationController
  serialization_scope nil

  def show
    post = Post.find(params['id'])
    render json: post
  end
end
