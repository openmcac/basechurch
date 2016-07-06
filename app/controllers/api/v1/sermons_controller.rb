class Api::V1::SermonsController < ApplicationResourceController
  before_action :authenticate_user!, except: [
    :get_related_resource,
    :show
  ]

  def sign
    render json: S3Signer.new.sign(type: params[:type], directory: "sermons"),
           status: :ok
  end
end
