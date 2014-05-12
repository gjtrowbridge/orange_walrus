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

  describe "index" do
    before do
      visit activities_path
    end
    describe "pagination" do
      before(:all) { 10.times { FactoryGirl.create(:activity) } }
      after(:all) do
        Activity.delete_all
        User.delete_all
      end

      #it { should have_selector('div.pagination') }

      it "should list each activity" do
        Activity.paginate(page: 1, per_page: 10).each do |activity|
          expect(page).to have_selector('li', text: activity.name)
        end
      end
      it "should have links to each activity" do
        Activity.paginate(page: 1).each do |activity|
          page { should have_link activity.name, href: activity_path(activity) }
        end
      end
    end
  end

  describe "show" do
    let(:activity) { FactoryGirl.create(:activity) }
    before do
      visit activity_path(activity)
    end

    it { should have_content activity.name }
    it { should have_content activity.description }
  end

  describe "new" do
    before do
      visit add_activity_path
    end
    describe "page" do
      it { should have_title("Add Activity") }
      it { should have_content("New Activity") }

      describe "with invalid information" do
        it "should not create an activity" do
          expect { click_button "Create Activity" }.not_to change(Activity, :count)
        end
      end

      describe "with valid information" do
        before do
          fill_in "Name", with: "Sample Activity1"
          fill_in "Description", with: "This is a sample activity"
        end
        it "should create an activity" do
          expect { click_button "Create Activity" }.to change(Activity, :count)
        end

        describe "after saving an activity" do
          before { click_button "Create Activity" }
          it { should have_content "Sample Activity1" }
          it { should have_content "This is a sample activity" }

        end

      end
    end
  end

  describe "edit" do
    let(:activity) { FactoryGirl.create(:activity, user: user) }
    before do
      visit edit_activity_path(activity)
    end
    describe "page" do
      it { should have_title "Edit Activity" }
    end
    describe "with valid information" do
      let(:new_name) { "Edited Activity Name" }
      let(:new_description) { "Edited Activity Description" }
      before do
        fill_in "Name",         with:new_name
        fill_in "Description",  with:new_description
        click_button "Update Activity"
      end
      it { should have_title(new_name) }
      it { should have_content(new_description) }
      specify { expect(activity.reload.name).to eq new_name }
      specify { expect(activity.reload.description).to eq new_description }
    end
  end

end
