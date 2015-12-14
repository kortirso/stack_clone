FactoryGirl.define do
    factory :user do
        sequence(:email) { |i| "tester#{i}@gmail.com" }
        password "password"
        admin false

        trait :admin do
            admin true
        end
    end
end