class Basechurch::V1::PostsController < Basechurch::ApplicationController
  before_action :authenticate_user!, except: [:show]

  def sign
    render json: S3Signer.new.sign(type: params[:type], directory: "posts"),
           status: :ok
  end
end
