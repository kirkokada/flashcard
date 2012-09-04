namespace :db do 
	desc "Fill database with sample data"
	task populate: :environment do 
		admin = User.create!(name: "Example User",
			                   email: "user@example.com",
			                   password: "password",
			                   password_confirmation: "password")
		admin.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "user-#{n+1}@example.com"
			User.create!(name: name,
				           email: email,
				           password: "password",
				           password_confirmation: "password")
		end
		users = User.all(limit: 6)
		50.times do 
			title = Faker::Company.bs
			description = Faker::Company.catch_phrase
			users.each do |user|
				user.decks.create!(title: title, description: description)
			end
		end
	end
end