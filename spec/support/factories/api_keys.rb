FactoryGirl.define do
  factory :api_key, class: Basechurch::ApiKey do
    user
    scope Forgery('lorem_ipsum').word
  end
end
