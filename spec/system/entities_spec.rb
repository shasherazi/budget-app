require_relative '../rails_helper'

RSpec.describe 'Entities', type: :system do
  let(:user) { User.create(name: 'First User', email: 'test@user.com', password: 'password') }
  before do
    # comment the line below to run tests in browser
    # driven_by(:rack_test)

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

  it 'displays all entities and their names, and dates', js: true do
    visit group_path(Group.first)
    Group.first.entities.each do |entity|
      expect(page).to have_content(entity.name)
      expect(page).to have_content(entity.created_at.strftime("%B%e, %Y%l:%M %p\n"))
    end
    sleep(5)
  end
end
