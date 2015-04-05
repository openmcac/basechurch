class Basechurch::V1::BulletinResource < JSONAPI::Resource
  attributes :id,
             :description,
             :name,
             :service_order
  attribute :published_at, format: :iso8601

  has_one :group
  has_many :announcements

  model_name 'Basechurch::Bulletin'

  filter :latest_for_group

  def self.apply_filter(records, filter, value)
    case filter
    when :latest_for_group
      records.latest.where(group_id: value).limit(1)
    else
      return super(records, filter, value)
    end
  end
end
