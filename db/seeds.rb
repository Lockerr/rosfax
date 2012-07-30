# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
u = User.new(
  :email => "test1@local.local",
  :password => 'secret'
)
u.save!(:validate => false)

u = User.new(
  :email => "test2@local.local",
  :password => 'secret'
)
u.save!(:validate => false)

u = User.new(
  :email => "test3@local.local",
  :password => 'secret'
)
u.save!(:validate => false)

u = User.new(
  :email => "test4@local.local",
  :password => 'secret'
)
u.save!(:validate => false)

u = User.new(
  :email => "test5@local.local",
  :password => 'secret'
)
u.save!(:validate => false)

