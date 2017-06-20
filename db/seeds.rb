# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(email: Rails.application.secrets.admin_email, password: Rails.application.secrets.admin_password, password_confirmation: Rails.application.secrets.admin_password)AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')