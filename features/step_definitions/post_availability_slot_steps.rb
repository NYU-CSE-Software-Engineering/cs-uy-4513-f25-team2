Given('I am signed in and verified tutor') do
  tutor = FactoryBot.create(:tutor, verified: true)
  visit new_tutor_session_path
  fill_in 'Email', with: tutor.email
  fill_in 'Password', with: tutor.password
  click_button 'Log in'
end

Given('I am on new slot page,') do
  visit new_tutor_slot_path
end

When('I fill in "Start Time" with {string}') do |datetime|
  fill_in 'Start Time', with: datetime
end

When('I fill in "End Time" with {string}') do |datetime|
  fill_in 'End Time', with: datetime
end

When('I fill in "Capacity" with {string}') do |capacity|
  fill_in 'Capacity', with: capacity
end

When('I fill in "Subject" with {string}') do |subject|
  fill_in 'Subject', with: subject
end

When('I press "Create new availability slot"') do
  click_button 'Create new availability slot'
end

Then("I should be on the slot's show page") do
  expect(page).to have_current_path(slot_path(Slot.last))
end

Then('I should see the message {string}') do |message|
  expect(page).to have_content(message)
end

Then('I should see the slot on the page') do
  expect(page).to have_content(Slot.last.subject)
end

Then('I should see an error message saying it is missing information') do
  expect(page).to have_content("Missing information")
end

Then('I should see an error message that there is a time conflict') do
  expect(page).to have_content("Time conflict")
end

Given("I am on the slot's show page") do
  slot = Slot.last
  visit slot_path(slot)
end

When('I press on "Delete"') do
  click_link 'Delete'
end

Then("I should be on tutor's slots page") do
  expect(page).to have_current_path(tutor_slots_path)
end