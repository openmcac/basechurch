FactoryGirl.define do
  factory :announcement do
    bulletin
    post
    description Forgery(:lorem_ipsum).words(100)
  end
end
