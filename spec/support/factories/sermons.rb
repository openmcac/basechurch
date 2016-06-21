FactoryGirl.define do
  factory :sermon do
    group
    published_at { DateTime.now }
    speaker { Forgery('name').full_name }
  end
end
