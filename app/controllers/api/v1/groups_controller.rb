class Api::V1::GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :get_related_resources]

  def sign
    render json: S3Signer.new.sign(type: params[:type], directory: "groups"),
           status: :ok
  end
end
