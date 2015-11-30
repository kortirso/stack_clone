FactoryGirl.define do
    factory :comment do
        body 'Comment'
        association :user
    end
    factory :comment_for_question, class: 'Comment' do
        body 'Comment'
        association :user
        association :commentable, factory: :question
        trait :mistake do
            body nil
        end
    end
    factory :comment_for_answer, class: 'Comment' do
        body 'Comment'
        association :user
        association :commentable, factory: :answer
        trait :mistake do
            body nil
        end
    end
end
