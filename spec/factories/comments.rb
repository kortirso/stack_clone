FactoryGirl.define do
    factory :comment do
        body 'Comment'
        association :user
    end
    factory :comment_for_question, class: 'Comment' do
        body 'Comment'
        association :user
        association :commentable, factory: :question
    end
    factory :comment_for_answer, class: 'Comment' do
        body 'Comment'
        association :user
        association :commentable, factory: :answer
    end
end
