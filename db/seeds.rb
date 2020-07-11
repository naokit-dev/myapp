# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# メインのサンプルユーザーを1人作成する
User.create!(username:  "naokit",
             email: "naokit@mail.com",
             password:              "password",
             password_confirmation: "password")

# 追加のユーザーをまとめて生成する
19.times do |n|
  name  = "user#{n+1}"
  email = "user-#{n+1}@mail.com"
  password = "password"
  User.create!(username:  name,
               email: email,
               password:              password,
               password_confirmation: password)

end