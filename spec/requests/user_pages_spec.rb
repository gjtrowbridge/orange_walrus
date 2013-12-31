require 'spec_helper'

describe "User Pages" do

  subject { page }

  describe "index" do
    before do
      valid_signin FactoryGirl.create(:user)
      FactoryGirl.create(:user, display_name: "Scott", email: "scott@example.com")
      FactoryGirl.create(:user, display_name: "Mark", email: "mark@example.com")
      visit users_path
    end
    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user)} }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.display_name)
        end
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_content(user.display_name) }
    it { should have_title(user.display_name) }
  end

  describe "signup page" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Display Name", with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.display_name) }
        it { should have_selector('div.alert.alert-success', text: 'New account created successfully!') }
      end

    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      valid_signin user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit User") }
    end
    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end
    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Display name",     with:new_name
        fill_in "Email",            with:new_email
        fill_in "Password",         with:user.password
        fill_in "Confirm Password", with:user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out') }
      specify { expect(user.reload.display_name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end
