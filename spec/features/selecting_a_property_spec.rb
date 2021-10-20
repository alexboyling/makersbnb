# frozen_string_literal: true
require 'pg'
require 'uri'
require 'property'

feature 'Seeing all properties' do
  scenario 'a user can see and book one of the existing' do
    sign_up
    create_listing1
    create_listing2
    visit('/')
    first(".property").click_button "Book"
    expect(current_path).to eq "/property/#{Property.all.first.id}/request-to-book"
    fill_in('start_date', with: 2022-01-01)
    fill_in('end_date', with: 2022-01-10)
    click_button("Request to Book")

    expect(page).to have_content("Your request has been sent")
  end
end