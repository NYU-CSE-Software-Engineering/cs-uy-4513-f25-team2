Given('I am signed in and verified tutor,') do
  @tutor = FactoryBot.create(:tutor, verified: true)
  visit new_tutor_session_path
  fill_in 'Email', with: @tutor.email
  fill_in 'Password', with: @tutor.password
  click_button 'Log in'
  expect(page).to have_content('Logged in successfully').or have_content('Dashboard')
end

Given('I am on new slot page,') do
  visit new_tutor_slot_path
end

When('I fill in "Start Time" with {string}') do |datetime_string|
  time = Time.parse(datetime_string)
  fill_in 'Start Time', with: time.strftime("%Y-%m-%d %H:%M")
end

When('I fill in "End Time" with {string}') do |datetime_string|
  time = Time.parse(datetime_string)
  fill_in 'End Time', with: time.strftime("%Y-%m-%d %H:%M")
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

Then('I should see the message that slot is deleted') do
  expect(page).to have_content("Slot deleted")
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

Given('the following slot exists:') do |table|
  table.hashes.each do |row|
    @existing_slot = AvailabilitySlot.create!(
      start_time: Time.parse(row['start_time']),
      end_time: Time.parse(row['end_time']),
      capacity: row['capacity'],
      subject: row['subject'],
      tutor: @tutor || Tutor.first
    )
  end
end

Then('I should see the message {string}') do |message|
  expect(page).to have_content(message)
end

When('I have an existing slot that overlaps') do
  new_start = @existing_slot.start_time - 30.minutes
  new_end   = @existing_slot.start_time + 30.minutes
  @overlaps = (new_start <= @existing_slot.end_time) && (new_end >= @existing_slot.start_time)
  @new_start_time = new_start
  @new_end_time = new_end
  expect(@overlaps).to be true
end