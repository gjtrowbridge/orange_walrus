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
    let!(:link1) { FactoryGirl.create(:activity_link, activity: activity, description: "Link to google", url: "www.google.com") }
    let!(:link2) { FactoryGirl.create(:activity_link, activity: activity, description: "Link to yahoo", url: "www.yahoo.com") }
    before do
      visit activity_path(activity)
    end

    it { should have_content activity.name }
    it { should have_content activity.description }
    it { should have_content activity.location }
    it { should have_content activity.cost }

    describe "activity links" do
      it { should have_content(link1.url) }
      it { should have_content(link2.url) }
      it { should have_content(link1.description) }
      it { should have_content(link2.description) }
    end

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

        describe "with link information listed" do
          before do
            fill_in "Link", with: "www.thisisaurl.com"
            click_button "Create Activity"
          end

          it { should have_content "www.thisisaurl.com" }
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
      let(:new_cost) { "Edited Activity Cost" }
      let(:new_location) { "Edited Activity Location" }
      let(:new_link) { "www.newlink.com" }
      before do
        fill_in "Name",         with:new_name
        fill_in "Description",  with:new_description
        fill_in "Cost",         with:new_cost
        fill_in "Location",     with:new_location
        fill_in "Link",         with:new_link
        click_button "Update Activity"
      end
      it { should have_title(new_name) }
      it { should have_content(new_description) }
      it { should have_content(new_cost) }
      it { should have_content(new_location) }
      it { should have_content(new_link) }

      specify { expect(activity.reload.name).to eq new_name }
      specify { expect(activity.reload.description).to eq new_description }
      specify { expect(activity.reload.cost).to eq new_cost }
      specify { expect(activity.reload.location).to eq new_location }
      specify { expect(activity.reload.activity_links.first).to eq new_link }
    end
  end

end
