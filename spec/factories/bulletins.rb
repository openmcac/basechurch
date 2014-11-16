FactoryGirl.define do
  factory :bulletin do
    group
    display_published_at DateTime.now.iso8601
    name Forgery(:lorem_ipsum).title
    service_order Forgery(:lorem_ipsum).words(10)
    description Forgery(:lorem_ipsum).words(10)
  end
end
