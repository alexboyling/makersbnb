# frozen_string_literal: true
require 'pg'
require 'uri'
require 'property'

feature 'Seeing all properties' do
  scenario 'a user can see and book one of the existing' do
    sign_up
    create_listing1
    DatabaseConnection.query("UPDATE bookings SET booking_status = 'confirmed';")
    create_listing2
    visit('/')
    first(".property").click_button "Book"

    expect(page).to have_content("Your request has been sent")
  end
end