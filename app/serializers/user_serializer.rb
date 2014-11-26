class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  has_one :session_api_key
end
