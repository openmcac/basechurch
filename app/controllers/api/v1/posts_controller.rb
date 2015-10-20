class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :get_related_resources]

  def sign
    render json: S3Signer.new.sign(type: params[:type], directory: "posts"),
           status: :ok
  end
end
