FactoryGirl.define do
  factory :group, class: Basechurch::Group do
    name Forgery(:lorem_ipsum).title
  end
end
