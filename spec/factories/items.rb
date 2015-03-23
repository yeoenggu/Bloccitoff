FactoryGirl.define do

  factory :item do

    name          { Faker::Name.name }
    user
    description   { Faker::Lorem.sentence}
    created_at    { Time.now }
  end
end