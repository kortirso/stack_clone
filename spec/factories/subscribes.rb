FactoryGirl.define do
    factory :subscribe do
        association :user
        association :question
    end
end
