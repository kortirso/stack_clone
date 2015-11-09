FactoryGirl.define do
	factory :answer do
		body "Answer"
		association :question
	end
end
