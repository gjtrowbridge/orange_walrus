require 'spec_helper'

describe User do
  before do
    @user = User.new(display_name: "OW Test User", email: "testuser@orangewalrus.com",
                      password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:display_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "when display name is not present" do
    before { @user.display_name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when name is incorrect length" do
    it "should be invalid" do
      lengths = [2, 51]
      lengths.each do |l|
        @user.display_name = "x" * l
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email or name is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.display_name = 'Totally unique name'
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when display name is already taken" do
    before do
      user_with_same_name = @user.dup
      user_with_same_name.email = "totallyuniqueemail@orangewalrus.com"
      user_with_same_name.display_name = @user.display_name.upcase
      user_with_same_name.save
    end

    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "when password is not present" do
    before do
      @user = User.new(display_name: "No password user", email: "nopass@orangewalrus.com",
                        password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before do
      @user.password_confirmation = "mismatch"
    end
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end

  end



end
