FactoryGirl.define do
  factory :url do
    url { |n| "#{Faker::Internet.domain_name}#{n}" }
    created_by { Faker::Number.number(10) }
  end
end
