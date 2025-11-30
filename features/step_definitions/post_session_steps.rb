

Given('I am on new session page,') do
  visit new_tutor_session_path
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

When('I press "Create new session"') do
  click_button 'Create new session'
end

Then('I should see the message that session is deleted') do
  expect(page).to have_content("Session deleted")
end

Then('I should see the session on the page') do
  expect(page).to have_content(Session.last.subject)
end

Then('I should see an error message saying it is missing information') do
  expect(page).to have_content("Missing information")
end

Then('I should see an error message that there is a time conflict') do
  expect(page).to have_content("Time conflict")
end

Given("I am on the session's show page") do
  expect(page).to have_content(Session.last.subject)
end

When('I press on "Delete"') do
  click_link 'Delete'
end

Then("I should be on tutor's session's page") do
  expect(page).to have_current_path(tutor_sessions_path)
end

Given('the following session exists:') do |table|
  table.hashes.each do |row|
    subj = Subject.find_by!(name: row['subject'])
    tutor = Tutor.find_by!(learner: @current_learner)

    @current_session = TutorSession.find_or_create_by!(
      tutor: tutor,
      subject: subj,
      start_at: Time.iso8601(row['start_at']),
      end_at: Time.iso8601(row['end_at'])
    ) do |s|
      s.capacity = row['capacity'].to_i
      s.status = row['status']
    end
  end  
end

Then('I should see the message {string}') do |message|
  expect(page).to have_content(message)
end

When('this session overlaps with existing session') do
  (@start_time <= @current_session.end_time) && (@end_time >= @current_session.start_time)
end