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
    factory :answer_with_attachment, class: 'Answer' do
        body "Random answer"
        best false
        association :question
        association :user
        after(:create) do |answer|
            answer.attachments.create(attributes_for(:attachment))
        end
    end
    factory :answer_with_attachments, class: 'Answer' do
        body "Random answer"
        best false
        association :question
        association :user
        after(:create) do |answer|
            answer.attachments.create(attributes_for(:attachment))
            answer.attachments.create(attributes_for(:other_attachments))
        end
    end
end
