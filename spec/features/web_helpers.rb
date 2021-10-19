def sign_up
  visit("/")
  click_button "Sign Up"
  fill_in('name', with: 'Jane')
  fill_in('email', with: 'test@example.com')
  fill_in('password', with: 'password123')
  click_button "Submit"
end

def log_in
  visit '/home'
  click_button 'Log In'
  fill_in("email", with: 'test@example.com')
  fill_in("password", with: 'password123')
  click_button('Sign in')
end