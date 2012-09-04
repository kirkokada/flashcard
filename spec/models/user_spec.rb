require 'spec_helper'

describe User do
  before { @user = FactoryGirl.create(:user) }

  subject { @user }

  it { should respond_to(:admin) }
  it { should respond_to(:name) }
  it { should respond_to(:decks) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should be_valid }
  it { should_not be_admin }

  # Admin
  describe "with admin attribute set to 'true'" do 
    before do 
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end
  # Name
  describe "when name is not present" do 
  	before { @user.name = '' }

  	it { should_not be_valid }
  end

  describe "when name is too long" do 
  	before { @user.name = 'a' * 51 }

  	it { should_not be_valid }
  end

  #Email
  describe "when email is not present" do 
  	before { @user.email = '' }

  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
	  it "should be invalid" do
	    addresses = %w[user@foo,com user_at_foo.org example.user@foo.
	                   foo@bar_baz.com foo@bar+baz.com]
	    addresses.each do |invalid_address|
	      @user.email = invalid_address
	      @user.should_not be_valid
	    end      
	  end
  end

  describe "when email format is valid" do 
  	it "should be valid" do 
  		addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
  		addresses.each do |valid_address|
  			@user.email = valid_address
  			@user.should be_valid
  		end
  	end
  end

  describe "email address with mixed case" do 
    let(:mixed_case_email) { "ExAmPlE@ExAmPlE.CoM" }

    it "should be saved as all lower-case" do 
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end

  describe "when email is already taken" do 
    let(:user_with_same_email) { @user.dup }
    before { user_with_same_email.email = @user.email.upcase }

    specify { user_with_same_email.should_not be_valid }
  end

  #password

  describe "when password is not present" do 
    before { @user.password = @user.password_confirmation = "" }
    it { should_not be_valid }
  end

  describe "when password and confirmation do not match" do 
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do 
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when password is too short" do 
    before { @user.password = @user.password_confirmation = "short" }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do 
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do 
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do 
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  #remember token
  describe "remember token" do 
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "deck relations" do 
    let(:older_deck) { FactoryGirl.create(:deck, user: @user, updated_at: 1.day.ago) }
    let(:recent_deck) { FactoryGirl.create(:deck, user: @user, updated_at: 1.hour.ago) }

    it "should have the right decks in the right order" do 
      @user.decks.should == [recent_deck, older_deck]
    end

    it "should destroy associated decks" do 
      decks = @user.decks
      @user.destroy
      decks.each do |deck|
        Deck.find_by_id(deck.id).should be_nil
      end
    end
  end
end
