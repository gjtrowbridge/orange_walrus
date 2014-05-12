require 'spec_helper'

describe Activity do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @activity = user.activities.build(name: "Kickball", description: "A big red ball + your foot.")
  end

  subject { @activity }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:location) }
  it { should respond_to(:links) }
  it { should respond_to(:cost) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user id is not present" do
    before { @activity.user_id = nil }
    it { should_not be_valid }
  end

  describe "when activity name is not present" do
    before { @activity.name = " " }
    it { should_not be_valid }
  end

end
