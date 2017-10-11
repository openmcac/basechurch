namespace :attachments do
  desc "Copy existing attachments over to new table"
  task copy: :environment do
    Basechurch::Post.find_each do |p|
      if p.banner_url
        Basechurch::Attachment.create(element_id: p.id,
                                      element_type: p.class.name,
                                      element_key: "banner",
                                      url: p.banner_url)
      end
    end

    Basechurch::Bulletin.find_each do |b|
      if b.banner_url
        Basechurch::Attachment.create(element_id: b.id,
                                      element_type: b.class.name,
                                      element_key: "banner",
                                      url: b.banner_url)
      end

      if b.audio_url
        Basechurch::Attachment.create(element_id: b.id,
                                      element_type: b.class.name,
                                      element_key: "audio",
                                      url: b.audio_url)
      end
    end
  end
end
