FactoryGirl.define do
  factory :user do
    name Forgery(:name).full_name
    email { Forgery(:email).address }
    password Forgery(:lorem_ipsum).words(2)
  end
end

