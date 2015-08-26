class Basechurch::Bulletin < ActiveRecord::Base
  belongs_to :group
  has_many :announcements

  validates :group, presence: true
  validates :published_at, presence: true

  has_one :audio,
          -> { where(key: "audio") },
          as: :attachable,
          class_name: "Basechurch::Attachment"
  validates_associated :audio
  has_attachment :banner, allow_blank: true

  scope :english_service, -> { where(group_id: 1) }
  scope :latest, -> do
    where('published_at <= ?', DateTime.now).order('published_at DESC')
  end

  def audio_url
    audio.try(:url)
  end

  def audio_url=(url)
    (audio || self.build_audio(key: "audio")).url = url
  end
end
