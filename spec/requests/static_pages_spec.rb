require 'spec_helper'

describe "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_title(full_title(page_title)) }
    it { should have_link('orangewalrus') }
    it { should have_link('Sign in') }
    it { should have_link('Sign up') }
  end

  describe "Home page" do
    before { visit root_path }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"

    it { should have_link('Find Activities') }
    it { should have_link('Add Activities') }
  end
end