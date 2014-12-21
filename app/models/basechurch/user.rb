class Basechurch::User < ActiveRecord::Base
  has_many :api_keys

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def session_api_key
    api_keys.active.session.first_or_create
  end
end
