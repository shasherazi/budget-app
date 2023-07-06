require_relative '../rails_helper'

RSpec.describe 'Welcome', type: :system do
  it 'displays welcome message' do
    visit '/'
    expect(page).to have_content('Budgget')
  end

  it 'displays sign up link' do
    visit '/'
    expect(page).to have_link('SIGN UP')
  end

  it 'displays log in link' do
    visit '/'
    expect(page).to have_link('LOG IN')
  end
end
