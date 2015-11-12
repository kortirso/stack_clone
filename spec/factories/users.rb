FactoryGirl.define do
    factory :user do
        sequence(:email) { |i| "tester#{i}@gmail.com" }
        password "password"
    end
end