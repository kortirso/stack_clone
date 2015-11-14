FactoryGirl.define do
    factory :answer do
        body "Answer"
        association :question
        association :user
    end
    factory :invalid_answer, class: 'Answer' do
        body  nil
        association :question
        association :user
    end
end
