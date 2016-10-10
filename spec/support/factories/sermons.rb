FactoryGirl.define do
  factory :sermon do
    group
    name { Forgery('lorem_ipsum').sentence }
    published_at { DateTime.now }
    speaker { Forgery('name').full_name }
    audio_url { "http://#{Forgery('internet').domain_name}/audio.mp3" }
    banner_url { "http://#{Forgery('internet').domain_name}/banner.jpg" }

    trait :completed do
      notes { Forgery(:lorem_ipsum).words(10) }
      speaker { Forgery('name').full_name }
      series { Forgery('lorem_ipsum').title }
    end
  end
end
