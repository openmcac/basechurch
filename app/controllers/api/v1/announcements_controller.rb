class Api::V1::AnnouncementsController < ApplicationResourceController
  before_action :authenticate_user!,
                except: [:show, :index, :get_related_resources]
end
