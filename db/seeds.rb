require "forgery"

unless Rails.env.test?
  group = Group.create!(name: 'English Service',
                        target_audience: "Members and seekers",
                        meet_details: "Sundays at 9:30am",
                        short_description: "Worship service for the English congregation",
                        about: "Welcome friends and visitors. We invite you to make MCAC your spiritual home and to worship with us every Sunday morning at 9:30am. Please let us know how we can be of help to you.

  The 2016 Church theme is [Equip to Shepherd](http://mcac.church/english-service/2016-church-theme-equip-to-shepherd). *“...to equip his people for works of service, so that the body of Christ may be built up”* (Ephesians 4:12)

  How can we pray for you? Let us know by [filling out a prayer request card](http://goo.gl/forms/vVNZxMsFFO).")

  user = User.create!(email: 'test@example.com',
                      password: 'password',
                      provider: "email")

  def service_order
    " - ## Call to Worship
   - ## Praise & Worship
   - ## Announcements
   - ## Offering
   - ## Sermon
     #{Forgery('lorem_ipsum').words(Random.rand(1..8), random: true).capitalize}  
     #{["Pastor Ryan", "Rev. Thomas Chan", "Rev. Marshall Davis"].sample}  
   - ## Doxology
   - ## Benediction"
  end

  def create_bulletin!(group)
    order = service_order

    sermon =
      Sermon.create!(group_id: group.id,
                     published_at: Random.rand(1000).days.ago,
                     name: Forgery('lorem_ipsum').title(random: true),
                     audio_url: "https://mcac.s3.amazonaws.com/bulletins/70422ae2-7a4a-4932-93d6-3c5cf057f62c.mp3",
                     notes: Forgery('email').body(random: true),
                     speaker: speaker(order))

    bulletin =
      Bulletin.create!(published_at: sermon.published_at,
                       group: group,
                       name: Forgery('lorem_ipsum').title(random: true),
                       service_order: order,
                       sermon_id: sermon.id)

    (6 + Random.rand(5)).times do
      bulletin.announcements.build(description: Forgery('lorem_ipsum').sentences(Random.rand(7), random: true)).save
    end
  end

  def create_post!(group, author)
    Post.create!(published_at: Random.rand(1000).days.ago,
                 group: group,
                 author: author,
                 title: Forgery('lorem_ipsum').title(random: true),
                 content: Forgery('email').body(random: true))
  end

  def speaker(string)
    return "Pastor Ryan Lee" if string =~ /ryan|lee/i
    return "Rev. Marshall Davis" if string =~ /marshall|davis/i
    return "Rev. Thomas Chan" if string =~ /thomas|chan/i

    return "MCAC"
  end

  unless Rails.env.production?
    100.times do
      create_bulletin!(group)
      create_post!(group, user)
    end
  end
end
