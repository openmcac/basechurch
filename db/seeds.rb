require "forgery"

group = Group.create!(name: 'English Service',
                      target_audience: "Members and seekers",
                      meet_details: "Sundays at 9:30am",
                      short_description: "Worship service for the English congregation",
                      about: "Welcome friends and visitors. We invite you to make MCAC your spiritual home and to worship with us every Sunday morning at 9:30am. Please let us know how we can be of help to you.

The 2016 Church theme is [Equip to Shepherd](http://mcac.church/english-service/2016-church-theme-equip-to-shepherd). *“...to equip his people for works of service, so that the body of Christ may be built up”* (Ephesians 4:12)

How can we pray for you? Let us know by [filling out a prayer request card](http://goo.gl/forms/vVNZxMsFFO).")
User.create!(email: 'test@example.com',
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

unless Rails.env.production?
  100.times do
    bulletin =
      Bulletin.create!(published_at: Random.rand(1000).days.ago,
                      group: group,
                      name: Forgery('lorem_ipsum').title(random: true),
                      description: "#{ Forgery('lorem_ipsum').word(random: true).capitalize } #{ Forgery('lorem_ipsum').words(Random.rand(5), random: true) }",
                      service_order: service_order,
                      sermon_notes: Forgery('email').body(random: true))

    bulletin.audio_url = "https://mcac.s3.amazonaws.com/bulletins/70422ae2-7a4a-4932-93d6-3c5cf057f62c.mp3"
    bulletin.save!

    (6 + Random.rand(5)).times do
      bulletin.announcements.build(description: Forgery('lorem_ipsum').sentences(Random.rand(7), random: true)).save
    end
  end
end
