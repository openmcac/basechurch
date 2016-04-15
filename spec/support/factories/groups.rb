FactoryGirl.define do
  factory :group do
    name Forgery(:lorem_ipsum).title
    short_description Forgery('lorem_ipsum').characters(140)
    meet_details Forgery('lorem_ipsum').characters(50)
    target_audience Forgery('lorem_ipsum').characters(50)
  end
end
