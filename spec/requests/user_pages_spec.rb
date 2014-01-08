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
      before(:all) { 20.times { FactoryGirl.create(:user)} }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1, per_page: 20).each do |user|
          expect(page).to have_selector('li', text: user.display_name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_out
          valid_signin admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end

  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:a1) { FactoryGirl.create(:activity, user: user, name: "Activity 1") }
    let!(:a2) { FactoryGirl.create(:activity, user: user, name: "Activity 2") }

    before { visit user_path(user) }
    it { should have_content(user.display_name) }
    it { should have_title(user.display_name) }

    describe "activities" do
      it { should have_content(a1.name) }
      it { should have_content(a2.name) }
      it { should have_content(user.activities.count) }
    end

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
        fill_in "Display name", with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
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

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
            password_confirmation: user.password } }
      end
      before do
        valid_signin user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end
