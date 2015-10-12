FactoryGirl.define do
  factory :user, aliases: [:author, :editor] do
    name Forgery(:name).full_name
    email { Forgery(:email).address }
    password Forgery(:lorem_ipsum).words(2)
    uid { Forgery('basic').number(at_least: 1000, at_most: 9999).to_s }
    provider "facebook"
  end
end
