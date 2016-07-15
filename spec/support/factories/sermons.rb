FactoryGirl.define do
  factory :sermon do
    group
    name { Forgery('lorem_ipsum').sentence }
    published_at { DateTime.now }
    speaker { Forgery('name').full_name }
  end
end
