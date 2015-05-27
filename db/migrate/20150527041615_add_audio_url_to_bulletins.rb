class AddAudioUrlToBulletins < ActiveRecord::Migration
  def change
    add_column :basechurch_bulletins, :audio_url, :string
  end
end
