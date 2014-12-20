FactoryGirl.define do
  factory :group do
    name Forgery(:lorem_ipsum).title
  end
end
