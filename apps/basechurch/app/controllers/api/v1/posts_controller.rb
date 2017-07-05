class Api::V1::PostsController < ApplicationResourceController
  before_action :authenticate_user!, except: [
    :get_related_resources,
    :index,
    :show
  ]

  def sign
    signed_response = S3Signer.new.sign(type: params[:type], directory: "posts")
    render json: signed_response, status: :ok
  end
end
