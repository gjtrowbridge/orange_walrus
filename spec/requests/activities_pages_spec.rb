require 'spec_helper'

describe "Activities Pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { valid_signin user }

  describe "activity creation" do
    before { visit add_activity_path }

    describe "with invalid information" do
      it "should not create an activity" do
        expect { click_button "Create" }.not_to change(Activity, :count)
      end

      describe "error messages" do
        before { click_button "Create" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { fill_in 'activity_name', with: "Activity name" }
      it "should create an activity" do
        expect { click_button "Create" }.to change(Activity, :count).by(1)
      end
    end

  end
end
