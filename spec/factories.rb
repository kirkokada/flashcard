FactoryGirl.define do 
	factory :user do 
		sequence(:name)     { |n| "Example User #{n}"}
		sequence(:email)    { |n| "user#{n}@example.com" }
		password "password"
		password_confirmation "password"

		factory :admin do 
			admin true
		end
	end

	factory :deck do 
		sequence(:title) { |n| "Deck #{n}" }
		sequence(:description) { |n| "This is deck number #{n}." }
		user
	end

	factory :card do 
		sequence(:front_text) { |n| "Front text #{n}" }
		sequence(:back_text)  { |n| "Back text #{n}" }
		next_review DateTime.now
		deck
	end
end