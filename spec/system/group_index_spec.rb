require_relative '../rails_helper'

RSpec.describe 'Group Index', type: :system do
  let(:user) { User.create(name: 'First User', email: 'test@user.com', password: 'password') }
  before do
    # comment the line below to run tests in browser
    driven_by(:rack_test)

    puts "\nCreating test data..."

    5.times do |i|
      group = Group.create(name: "Group #{i}", author: user)
      group.icon.attach(io: File.open(Rails.root.join('spec', 'models', 'files', 'test.jpg')), filename: 'test.jpg',
                        content_type: 'image/jpeg')
      group.save

      5.times do |j|
        entity = Entity.create(name: "Entity #{j}", amount: 100, author: user)
        entity.save
      end
    end

    Group.all.each do |group|
      group.entities << Entity.all.sample(rand(1..3))
    end

    Entity.all.each do |entity|
      entity.groups << Group.all.sample(rand(1..3))
    end

    puts 'Logging in...'
    visit new_user_session_path
    fill_in 'user_email', with: 'test@user.com'
    fill_in 'user_password', with: 'password'
    click_button 'Log in'
  end

  after(:all) do
    puts "\nCleaning up..."
    Group.destroy_all
    Entity.destroy_all
    User.destroy_all
  end

  it 'displays all groups, their names, and icons', js: true do
    visit groups_path
    user.groups.each do |group|
      expect(page).to have_content(group.name)
      expect(page).to have_css("img[src*='#{group.icon.blob.filename}']")
    end
  end

  it 'displays entities of a group when clicked', js: true do
    visit groups_path
    user.groups.each do |group|
      click_link group.name
      group.entities.each do |entity|
        expect(page).to have_content(entity.name)
        expect(page).to have_current_path(group_path(group))
      end
      visit groups_path
    end
  end

  it 'can create a new group', js: true do
    visit new_group_path
    fill_in 'group_name', with: 'Newly created group'
    attach_file('group_icon', Rails.root.join('spec', 'models', 'files', 'test.jpg'))
    click_button 'Create Group'
    expect(page).to have_content('Newly created group')
  end
end
