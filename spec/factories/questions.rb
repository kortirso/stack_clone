FactoryGirl.define do
    factory :question do
        title "Title"
        body "Body"
        association :user
    end
    factory :invalid_question, class: 'Question' do
        title nil
        body  nil
        association :user
    end
end
