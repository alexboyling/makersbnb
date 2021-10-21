# frozen_string_literal: true

def sign_up
  visit('/')
  click_button 'Sign Up'
  fill_in('name', with: 'Jane')
  fill_in('email', with: 'test@example.com')
  fill_in('password', with: 'password123')
  click_button 'Sign up'
end

def log_in
  visit '/home'
  click_button 'Log In'
  fill_in('email', with: 'test@example.com')
  fill_in('password', with: 'password123')
  click_button('Sign in')
end

def create_listing1
  visit('/')
  click_button 'Create a listing'
  fill_in('name', with: '2 bed flat')
  fill_in('description', with: 'Nice neighbourhood, big balcony')
  fill_in('location', with: 'Walthamstow')
  fill_in('price', with: 135)
  click_button('Submit')
end 

def create_listing2
  visit('/')
  click_button 'Create a listing'
  fill_in('name', with: '4 bed flat')
  fill_in('description', with: 'Nice neighbourhood, no balcony')
  fill_in('location', with: 'Camden')
  fill_in('price', with: 155)
  click_button('Submit')
end 
