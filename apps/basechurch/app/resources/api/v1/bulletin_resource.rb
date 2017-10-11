class Api::V1::BulletinResource < JSONAPI::Resource
  attributes :name, :service_order, :banner_url

  attribute :published_at, format: :iso8601

  has_one :group
  has_one :sermon
  has_many :announcements

  filter :latest_for_group
  filter :group

  def self.apply_filter(records, filter, value, options)
    case filter
    when :group
      records.where(group_id: value)
    when :latest_for_group
      records.latest.where(group_id: value).limit(1)
    else
      return super(records, filter, value, options)
    end
  end
end
