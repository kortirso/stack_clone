FactoryGirl.define do
    factory :subscribe do
        association :user
        association :subscribeable, factory: :question
    end
end
