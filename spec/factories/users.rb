# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    gender { :female }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :non_female_user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    gender { :male }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
