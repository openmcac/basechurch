FactoryGirl.define do
  factory :bulletin, class: Basechurch::Bulletin do
    group
    display_published_at DateTime.now.iso8601
    name Forgery(:lorem_ipsum).title
    service_order Forgery(:lorem_ipsum).words(10)
    description Forgery(:lorem_ipsum).words(10)

    factory :bulletin_with_announcements, class: Basechurch::Bulletin do
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
