# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "Creating admin user"
adminuser = User.create({ email: 'craig@yoyozi.com',first_name: 'Craig', last_name: 'Leppan', password: '111111', password_confirmation: '111111', role: "admin" })
puts "creating normal user"
users = User.create({ email: 'puser@aaa.com',first_name: 'puser', last_name: 'pplan', password: '111111', password_confirmation: '111111', role: "puser" })
puts "creating normal user"
users = User.create({ email: 'nuser@aaa.com',first_name: 'nuser', last_name: 'pplan', password: '111111', password_confirmation: '111111', role: "nuser" })