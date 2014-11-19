FactoryGirl.define do
  factory :user do
    email Forgery(:email).address
    password Forgery(:basic).encrypt
  end
end

