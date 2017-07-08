FactoryGirl.define do
  factory :attachment do
    url "http://www.#{Forgery('internet').domain_name}/#{Forgery('basic').encrypt}.jpg"
  end
end
