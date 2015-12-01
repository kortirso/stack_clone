FactoryGirl.define do
    factory :question do
        title "Test question title"
        body "Test question body"
        association :user
    end
    factory :invalid_question, class: 'Question' do
        title nil
        body  nil
        association :user
    end
    factory :question_with_attachment, class: 'Question' do
        title "Title"
        body "Body"
        association :user
        after(:create) do |question|
            question.attachments.create(attributes_for(:attachment))
        end
    end
end
