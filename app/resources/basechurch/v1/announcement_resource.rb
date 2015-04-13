class Basechurch::V1::AnnouncementResource < JSONAPI::Resource
  attributes :id, :description, :position

  has_one :bulletin
  has_one :post

  model_name 'Basechurch::Announcement'

  filter :latest_for_group
  filter :defaults_for_bulletin

  def self.apply_filter(records, filter, value)
    case filter
    when :latest_for_group
      records.where('basechurch_announcements.bulletin_id = ?',
                    self.get_latest_bulletin!(value))
    when :defaults_for_bulletin
      records.where('basechurch_announcements.bulletin_id = ?',
                    self.get_previous_bulletin(value))
    else
      return super(records, filter, value)
    end
  end

private
  def self.get_previous_bulletin(bulletin_id)
    bulletin = Basechurch::Bulletin.where(id: bulletin_id).first
    Basechurch::Bulletin.latest.
                         where('published_at < ?', bulletin.published_at).
                         where(group_id: bulletin.group_id).
                         first
  end

  def self.get_latest_bulletin!(group_id)
    latest_bulletin =
        Basechurch::Bulletin.latest.where(group_id: group_id).first
    return latest_bulletin if latest_bulletin

    raise(ArgumentError,
          "Unable to find published bulletin for group #{group_id}")
  end
end
