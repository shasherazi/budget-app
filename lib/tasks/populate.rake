require 'faker'
require 'open-uri'

def image_fetcher
  URI.open(Faker::Company.logo)
rescue StandardError
  URI.open('https://robohash.org/sitsequiquia.png?size=300x300&set=set1')
end

namespace :db do
  desc 'Populate database with sample data'
  task populate: :environment do
    puts 'Recreating database...'

    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke

    puts 'Database recreated.'

    user = User.create!(
      name: 'First User',
      email: 'testuser@test.com',
      password: 'password',
      confirmed_at: Time.now
    )

    5.times do
      g = Group.new(
        name: Faker::Commerce.department(max: 1),
        author: user
      )

      g.icon.attach(io: image_fetcher, filename: 'icon.png', content_type: 'image/png')
      g.save!
    end

    10.times do
      Entity.create!(
        name: Faker::Commerce.product_name,
        amount: Faker::Number.between(from: 1, to: 1000),
        author: user
      )
    end

    # add some groups to entities and some entities to groups coz many-to-many
    Entity.all.each do |entity|
      entity.groups << Group.all.sample(rand(1..3))
    end

    Group.all.each do |group|
      group.entities << Entity.all.sample(rand(1..3))
    end

    puts 'Database populated!'

    5.times do
      user = User.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: 'password'
      )

      5.times do
        g = Group.new(
          name: Faker::Commerce.department(max: 1),
          author: user
        )

        g.icon.attach(io: image_fetcher, filename: 'icon.png', content_type: 'image/png')
        g.save!

        Entity.create!(
          name: Faker::Commerce.product_name,
          amount: Faker::Number.between(from: 1, to: 1000),
          author: user
        )
      end

      Entity.all.each do |entity|
        entity.groups << Group.all.sample(rand(1..3))
      end

      Group.all.each do |group|
        group.entities << Entity.all.sample(rand(1..3))
      end
    end
  end
end
