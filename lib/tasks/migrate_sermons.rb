class MigrateSermons
  def process
    Bulletin.find_each do |b|
      next unless b.audio_url
      Sermon.create(group_id: b.group_id,
                    published_at: b.published_at,
                    audio_url: b.audio_url,
                    notes: b.sermon_notes,
                    speaker: speaker(b.service_order))
    end
  end

  private

  def speaker(string)
    return "Pastor Ryan Lee" if string =~ /ryan|lee/i
    return "Rev. Marshall Davis" if string =~ /marshall|davis/i
    return "Rev. Thomas Chan" if string =~ /thomas|chan/i

    return "MCAC"
  end
end
