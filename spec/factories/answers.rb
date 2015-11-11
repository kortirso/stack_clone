FactoryGirl.define do
  factory :answer do
    body "Answer"
    association :question
  end
  factory :invalid_answer, class: 'Answer' do
    body  nil
    association :question
  end
end
