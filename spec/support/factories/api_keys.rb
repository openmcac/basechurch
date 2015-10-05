FactoryGirl.define do
  factory :api_key do
    user
    scope Forgery('lorem_ipsum').word
  end
end
