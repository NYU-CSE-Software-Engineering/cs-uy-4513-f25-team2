Given('I am a signed-in tutor') do
  @current_learner ||= Tutor.find_or_create_by!(email: "mia.patel@example.com") do |t|
    t.password   = "password123"
    t.first_name = "Mia"
    t.last_name  = "Patel"
  end
end

Given('the subject {string} exists') do |subject_name|
  Subject.find_or_create_by!(name: subject_name) do |s|
    s.code = subject_name.parameterize.upcase.first(6)
    s.description = "#{subject_name} subject"
  end
end

Given('the following learner exists:') do |table|
  table.hashes.each do |row|
    Learner.find_or_create_by!(first_name: row['first_name'], last_name: row['last_name']) do |l|
      l.email = row['email']
      l.password = row['password']
    end
  end
end

Given('the following session exists:') do |table|
  table.hashes.each do |row|
    subj = Subject.find_by!(name: row['subject'])
    tutor = Tutor.find_by!(first_name: 'Mia', last_name: 'Patel')
    tutee = Learner.find_by!(first_name: 'Jane', last_name: 'Doe')

    @current_session = Session.find_or_create_by!(
      tutor: tutor,
      subject: subj,
      start_at: Time.iso8601(row['start_at']),
      end_at: Time.iso8601(row['end_at'])
    ) do |s|
      s.capacity = row['capacity'].to_i
      s.status = row['status']
      s.meeting_link = row['meeting_link']
    end

    SessionAttendee.find_or_create_by!(
      session: @current_session,
      learner: tutee
    ) do |a|
      a.attended = nil
      a.feedback_submitted = false
      a.cancelled = false
    end
  end
end

Given('I am on the "Session Details" page for the session at {string}') do |start_time|
  start_at = Time.iso8601(start_time)
  session = Session.find_by!(start_at: start_at)
  visit session_path(session)
end

Given('the learner is marked as {string}') do |attendance|
  # assumes present/absent are radio buttons
  choose(attendance)
  click_button 'Save'
end

Given('the learner\'s attendance is not marked') do
  expect(page).to have_field('Present', checked: false)
  expect(page).to have_field('Absent', checked: false) 
end

Given('the session has not yet occurred') do
  # hardcode the "current time" for the sake of testing
  @current_time = Time.iso8601("2025-10-20T12:00:00Z")
  expect(@current_time).to be_less_than(@current_session.start_at)
end

When('I mark the learner as {string}') do |attendance|
  choose(attendance)
end

When('I save the attendance') do
  click_button 'Save'
end

Then('I should see the message {string}') do |message|
  expect(page).to have_content(message)
end

Then('the learner\'s attendance for the session should be set to {string}') do |bool|
  attended = (bool == 'true')
  current_attendee = SessionAttendee.find_by!(session: @current_session, learner: @current_learner)
  expect(current_attendee.attended).to eq(attended)
end

Then('I should not see the {string} (option|button)') do |label, type|
  if type == "option"
    expect(page).not_to have_field(label)
  elsif type == "button"
    expect(page).not_to have_button(label)
  end
end

Then('I should not see the {string} option') do |radio|
    expect(page).not_to have_field(radio)
end

Then('I should not see the {string} button') do |button|
    expect(page).not_to have_button(button)
end
