require 'rails_helper'

RSpec.describe Voiting, type: :model do
  it { should belong_to :user }
  it { should belong_to :voitingable }
end
