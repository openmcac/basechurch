FactoryGirl.define do
  factory :post do
    group
    author
    content Forgery('lorem_ipsum').paragraphs
    kind :post

    factory :page do
      kind :page
    end

    trait :completed do
      banner_url { "http://#{Forgery('internet').domain_name}/banner.jpg" }
      published_at { 2.days.ago }
      tag_list { Forgery("lorem_ipsum").lorem_ipsum_words.sample(3) }
      title { Forgery("lorem_ipsum").title }
    end
  end
end
