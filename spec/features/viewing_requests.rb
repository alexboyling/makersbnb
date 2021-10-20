# frozen_string_literal: true

feature 'Viewing requests' do
  scenario 'can access the requests page' do
    sign_up
    log_in
    click_button 'Requests'
    expect(page).to have_content("Requests I've made") 
  end
end
