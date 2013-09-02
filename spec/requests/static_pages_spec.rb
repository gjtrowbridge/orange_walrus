require 'spec_helper'

describe "Static pages" do
  subject { page }

  describe "Home page" do
    before { visit '/static_pages/home' }

    it { should have_title('Orange Walrus') }
    it { should have_link('Find Activities') }
    it { should have_link('Add Activities') }
    it { should have_link('Sign in') }
    it { should have_link('Sign up') }
  end
end