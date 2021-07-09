require 'rails_helper'

shared_examples_for "voitingable" do
  it { should have_many(:voitings).dependent(:destroy) }
end