FactoryGirl.define do
  factory :post, class: Basechurch::Post do
    group
    author
    content Forgery('lorem_ipsum').paragraphs
  end
end
