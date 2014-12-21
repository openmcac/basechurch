class Basechurch::ApiKey < ActiveRecord::Base
  belongs_to :user

  before_create :generate_access_token, :set_expiry_date

  scope :session, -> { where(scope: 'session') }
  scope :api, -> { where(scope: 'api') }
  scope :active, -> { where('expired_at >= ?', Time.now) }

  private
  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while access_token_already_used?
  end

  def set_expiry_date
    self.expired_at = scope == 'session' ? 4.days.from_now : 30.days.from_now
  end

  def access_token_already_used?
    self.class.exists?(access_token: access_token)
  end
end
