FactoryGirl.define do
  factory :serverspec_report do
    host
    sequence(:reported_at) { |n| n.minutes.ago }
    status 0
  end
end
