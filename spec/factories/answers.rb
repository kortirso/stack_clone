FactoryGirl.define do
    factory :answer do
        body "Random answer"
        best false
        association :question
        association :user
    end
    factory :invalid_answer, class: 'Answer' do
        body  nil
        best false
        association :question
        association :user
    end
end
