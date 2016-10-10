FactoryGirl.define do
  factory :sermon do
    group
    name { Forgery('lorem_ipsum').sentence }
    published_at { DateTime.now }
    speaker { Forgery('name').full_name }

    trait :completed do
      notes { Forgery(:lorem_ipsum).words(10) }
      series { Forgery('lorem_ipsum').title }
      audio_url { "http://#{Forgery('internet').domain_name}/audio.mp3" }
      banner_url { "http://#{Forgery('internet').domain_name}/banner.jpg" }
    end
  end
end
