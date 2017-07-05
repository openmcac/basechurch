FactoryGirl.define do
  factory :group do
    name { Forgery(:lorem_ipsum).title }
    short_description { Forgery('lorem_ipsum').characters(140) }
    meet_details { Forgery('lorem_ipsum').characters(50) }
    target_audience { Forgery('lorem_ipsum').characters(50) }

    trait :completed do
      about { Forgery('lorem_ipsum').characters(140) }
      banner_url { "https://#{Forgery("internet").domain_name}/banner.png" }
      profile_picture_url { "https://#{Forgery("internet").domain_name}/profile-picture.png" }
    end
  end
end
