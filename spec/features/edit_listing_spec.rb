feature 'edit listing' do 
  scenario 'a user creates then edits a listing' do
    sign_up
    create_listing1
    expect(page).to have_content("2 bed flat")
    expect(page).to have_content("Nice neighbourhood, big balcony")
    expect(page).to have_content("Walthamstow")
    expect(page).to have_content("$135")

    expect(current_path).to eq "/property/portfolio"
    first(".property").click_button "Edit"
    fill_in('start_date', with: 2022-03-01)
    fill_in('end_date', with: 2022-04-10)
    fill_in('name', with: '6 bed flat')
    fill_in('description', with: 'Terrible neighbourhood')
    fill_in('location', with: 'East London')
    fill_in('price', with: 145)
    click_button('Submit')

    expect(page).to have_content('6 bed flat')
    expect(page).to have_content('Terrible neighbourhood')
    expect(page).to have_content('East London')
    expect(page).to have_content("$145")
  end 
end 