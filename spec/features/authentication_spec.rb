# frozen_string_literal: true

feature 'authentication' do
  it 'a user can sign in' do
    sign_up
    click_button 'Log Out'
    visit '/'
    click_button 'Log In'
    fill_in('email', with: 'test@example.com')
    fill_in('password', with: 'password123')
    click_button('Sign in')

    expect(page).to have_content('test@example.com')
    expect(page).to have_content('Jane')
  end

  scenario 'a user sees an error if they get their email wrong' do
    sign_up
    click_button 'Log Out'
    visit '/'
    click_button 'Log In'
    fill_in('email', with: 'not_the_right_user')
    fill_in('password', with: 'password123')
    click_button('Sign in')

    expect(page).not_to have_content('test@example.com')
    expect(page).not_to have_content('Jane')
    expect(page).to have_content 'Please check your email or password.'
  end

  scenario 'a user sees an error if they get their password wrong' do
    sign_up
    click_button 'Log Out'
    visit '/'
    click_button 'Log In'
    fill_in('email', with: 'test@example.com')
    fill_in('password', with: 'wrongpassword')
    click_button('Sign in')

    expect(page).not_to have_content('test@example.com')
    expect(page).not_to have_content('Jane')
    expect(page).to have_content 'Please check your email or password.'
  end

  scenario 'a user can Log out' do
    sign_up
    visit '/'
    click_button('Log Out')

    expect(page).not_to have_content('test@example.com')
    expect(page).not_to have_content('Jane')
    expect(page).to have_button 'Sign Up'
    expect(page).to have_button 'Log In'
  end
end
