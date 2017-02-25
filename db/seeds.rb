# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "Creating admin user"
adminuser = User.create({ email: 'craig@yoyozi.com',first_name: 'Craig', last_name: 'Leppan', password: '111111', password_confirmation: '111111', admin: 'true' })

puts "creating normal user"
users = User.create({ email: 'aig@aaa.com',first_name: 'aig', last_name: 'ppan', password: '111111', password_confirmation: '111111', admin: 'false' })