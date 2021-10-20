# frozen_string_literal: true

feature 'Create a listing' do 
  scenario 'a user list multiple properties' do 
    sign_up
    create_listing1
    expect(page).to have_content("2 bed flat")
    expect(page).to have_content("Nice neighbourhood, big balcony")
    expect(page).to have_content("Walthamstow")
    expect(page).to have_content("$135")
    create_listing2
    expect(page).to have_content("4 bed flat")
    expect(page).to have_content("Nice neighbourhood, no balcony")
    expect(page).to have_content("Camden")
    expect(page).to have_content("$155")
  end 

  scenario 'a user list one property' do 
    sign_up
    create_listing1
    expect(page).to have_content("2 bed flat")
    expect(page).to have_content("Nice neighbourhood, big balcony")
    expect(page).to have_content("Walthamstow")
    expect(page).to have_content("$135")
  end 
end 
