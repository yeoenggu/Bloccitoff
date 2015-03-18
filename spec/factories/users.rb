FactoryGirl.define do

  factory :user do

    transient do
      skip_confirmation true
    end

    
    name        { Faker::Name.name }
    email       { Faker::Internet.email }
    password    "helloworld"
    # id          { Faker::Number.number(2) }

    before(:create) do | user, evaluator |
      user.skip_confirmation! if evaluator.skip_confirmation
    end
  end
end
