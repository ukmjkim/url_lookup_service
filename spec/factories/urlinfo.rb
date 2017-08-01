FactoryGirl.define do
  factory :urlinfo do
    url { |n| "#{Faker::Internet.domain_name}#{n}" }
    malware { true }
    created_by { Faker::Number.number(10) }
  end
end
