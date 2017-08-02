FactoryGirl.define do
  factory :urlinfo do
    domain_name { "#{Faker::Internet.domain_name}" }
    query_string { "q=abc" }
    url { "#{domain_name}/?#{query_string}" }
    malware { true }
    created_by { "1" }
  end
end
