Given('I am a signed in user and tutor') do
  @current_learner ||= Tutor.find_or_create_by!(email: "mia.patel@example.com") do |t|
    t.password   = "password123"
    t.first_name = "Mia"
    t.last_name  = "Patel"
  end
end

Given('I am on new slot page,') do
  visit new_tutor_slot_path
end

When('I fill in "Start Time" with {string}') do |datetime_string|
  time = Time.parse(datetime_string)
  fill_in 'Start Time', with: time.strftime("%Y-%m-%d %H:%M")
  @start_time = Time.parse(datetime_string)
end

When('I fill in "End Time" with {string}') do |datetime_string|
  time = Time.parse(datetime_string)
  fill_in 'End Time', with: time.strftime("%Y-%m-%d %H:%M")
  @end_time = Time.parse(datetime_string)
end

When('I fill in "Capacity" with {string}') do |capacity|
  fill_in 'Capacity', with: capacity
  @capacity = capacity
end

When('I fill in "Subject" with {string}') do |subject|
  fill_in 'Subject', with: subject
  @subject = subject
end

When('I press "Create new availability slot"') do
  click_button 'Create new availability slot'
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
  expect(page).to have_content(Slot.last.subject)
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

When('this slot overlaps with existing slot') do
  (@start_time <= @existing_slot.end_time) && (@end_time >= @existing_slot.start_time)
end