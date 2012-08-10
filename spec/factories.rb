FactoryGirl.define do 
	factory :user do 
		sequence(:name)     { |n| "Michael Oldmoney #{n}"}
		sequence(:email)    { |n| "michaeloldmoney#{n}@example.com" }
		password "password"
		password_confirmation "password"

		factory :admin do 
			admin true
		end
	end
end