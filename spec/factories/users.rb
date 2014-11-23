FactoryGirl.define do
  factory :user do
    name Forgery(:name).full_name
    email { Forgery(:email).address }
    password Forgery(:basic).encrypt
  end
end

