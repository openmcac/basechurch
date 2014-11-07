FactoryGirl.define do
  factory :bulletin do
    date DateTime.now
    name Forgery(:lorem_ipsum).title
    service_order Forgery(:lorem_ipsum).words(10)
    description Forgery(:lorem_ipsum).words(10)
  end
end
