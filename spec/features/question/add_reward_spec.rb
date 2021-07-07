require 'rails_helper'

feature 'User can add reward for best to answer on question', %q{
  In order to appoint reward from best answer
  As an question author
  i'd like to be able to add reward
} do

  given(:user) { create(:user) }

  scenario 'User can add reward' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Text question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name reward', with: 'My Reward'
    attach_file 'File', "#{Rails.root}/app/assets/images/oscar.ico"

    click_on 'Ask'

    expect(page).to have_content 'My Reward'
  end

end