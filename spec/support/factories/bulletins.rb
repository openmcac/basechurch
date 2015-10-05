FactoryGirl.define do
  factory :bulletin do
    group
    published_at DateTime.now

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
