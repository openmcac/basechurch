class V1::AnnouncementsController < ApplicationController
  before_action :authenticate_user!,
                except: [:show, :index, :get_related_resources]
end
