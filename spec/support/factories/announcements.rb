FactoryGirl.define do
  factory :announcement, class: Basechurch::Announcement do
    bulletin
    post
    description Forgery(:lorem_ipsum).words(100)
  end
end
