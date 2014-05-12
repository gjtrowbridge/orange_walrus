require 'spec_helper'

describe ActivityLink do
  let(:user) { FactoryGirl.create(:user) }
  let(:activity) { FactoryGirl.create(:activity, user: user) }
  before do
    @activity_link = ActivityLink.new(url:"www.google.com", description:"Link to google", activity_id: activity.id)
  end

  subject { @activity_link }

  it { should respond_to(:url) }
  it { should respond_to(:description) }
  it { should respond_to(:activity_id) }

  describe "when activity_id is not present" do
    before { @activity_link.activity_id = nil }
    it { should_not be_valid }
  end

  describe "when url format is invalid" do
    it "should be invalid" do
      addresses = %w[foo,com user_dot_com example.com.]
      addresses.each do |invalid_url|
        @activity_link.url = invalid_url
        expect(@activity_link).not_to be_valid
      end
    end
  end

end
