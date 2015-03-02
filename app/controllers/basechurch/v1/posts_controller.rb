class Basechurch::V1::PostsController < Basechurch::ApplicationController
  before_action :authenticate_user!, except: [:show]
end
