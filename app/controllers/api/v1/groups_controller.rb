class Api::V1::GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def sign
    render json: S3Signer.new.sign(type: params[:type], directory: "groups"),
           status: :ok
  end
end
