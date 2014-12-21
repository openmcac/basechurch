class ApiKeySerializer < ActiveModel::Serializer
  attributes :access_token, :expired_at
  has_one :user, embed: :id

  def expired_at
    object.expired_at.utc.to_time.iso8601
  end
end
