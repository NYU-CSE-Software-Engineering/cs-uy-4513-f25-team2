Given('I am on new session page,') do
  visit new_tutor_session_path
end

When('I fill in the session start time with {string}') do |time_string|
  fill_in 'tutor_session_start_at', with: time_string
  @start_time = Time.parse(time_string)
end

When('I fill in the session end time with {string}') do |time_string|
  fill_in 'tutor_session_end_at', with: time_string
  @end_time = Time.parse(time_string)
end


#When('I fill in "Capacity" with {string}') do |capacity|
#  fill_in 'Capacity', with: capacity
#  @capacity = capacity
#end

#When('I fill in "Subject" with {string}') do |subject|
#  fill_in 'Subject', with: subject
#  @subject = subject
#end

When('I select {string} from {string}') do |value, field|
  select value, from: field
end

#When('I press "Create new session"') do
#  click_button 'Create new session'
#end

#Then('I should see the message that session is deleted') do
#  expect(page).to have_content("Session deleted")
#end

Then('I should see the session on the page') do
  expect(page).to have_content(TutorSession.last.subject.name)
end

Then('I should see an error message saying it is missing information') do
  expect(page).to have_content("can't be blank")
  #expect(page).to have_content("Capacity can't be blank")
end

Then('I should see an error message that there is a time conflict') do
  expect(page).to have_content("Session overlaps with existing session")
end

# these were all part of delete --> that will get its own feature
#Given("I am on the session's show page") do
#  expect(page).to have_content(Session.last.subject)
#end

#When('I press on "Delete"') do
#  click_link 'Delete'
#end

Then("I am on the session's show page") do
  expect(page).to have_current_path(tutor_session_path(TutorSession.last))
end

Given('the following session exists:') do |table|
  table.hashes.each do |row|
    subject = Subject.find_by(name: row['subject']) || Subject.create!(name: row['subject'], code: row['subject'].upcase)
    @existing_session = TutorSession.create!(
      tutor: @current_tutor,
      subject: subject,
      start_at: Time.parse(row['start_at']),
      end_at: Time.parse(row['end_at']),
      capacity: row['capacity'].to_i,
      status: 'open'
    )
  end
end

When('this session overlaps with existing session') do
  overlap = TutorSession
              .where(tutor: @current_tutor)
              .where("start_at < ? AND end_at > ?", @end_time, @start_time)
  expect(overlap.exists?).to be true
end


Then('I should see the message {string}') do |message|
  expect(page).to have_content(message)
end
