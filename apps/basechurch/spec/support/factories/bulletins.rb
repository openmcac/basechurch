FactoryGirl.define do
  factory :bulletin do
    group
    published_at { DateTime.now }

    trait :completed do
      banner_url { "http://#{Forgery('internet').domain_name}/banner.jpg" }
      name { Forgery(:lorem_ipsum).title }
      service_order { Forgery(:lorem_ipsum).words(10) }
    end

    factory :bulletin_with_announcements do
      transient do
        announcements_count 3
      end

      after(:create) do |bulletin, evaluator|
        create_list(:announcement,
                    evaluator.announcements_count,
                    bulletin: bulletin)
      end
    end
  end
end
