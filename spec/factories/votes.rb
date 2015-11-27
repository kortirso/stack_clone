FactoryGirl.define do
    factory :vote do
        association :user
        association :voteable
        value 0

        trait :question do
            association :voteable, factory: :question
        end

        trait :answer do
            association :voteable, factory: :answer
        end
    end
end
