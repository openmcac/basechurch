class Basechurch::V1::AnnouncementsController < Basechurch::ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
end
