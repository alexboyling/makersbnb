# frozen_string_literal: true

require 'pg'
require 'uri'

feature 'Registration' do
  scenario 'a user can sign-up' do
    visit('/')
    click_button 'Sign Up'
    fill_in('name', with: 'Jane')
    fill_in('email', with: 'test_email@example.com')
    fill_in('password', with: 'password123')
    click_button 'Submit'

    expect(page).to have_content('Jane')
    expect(page).to_not have_button('Sign Up')
  end
end
