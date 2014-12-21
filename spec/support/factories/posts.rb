FactoryGirl.define do
  factory :post do
    group
    author
    content Forgery('lorem_ipsum').paragraphs
  end
end
