Given('I am a signed-in tutor') do
  email    = 'mia.patel@example.com'
  password = 'password123'

  learner = Learner.find_or_create_by!(email: email) do |l|
    l.password   = password
    l.first_name = 'Mia'
    l.last_name  = 'Patel'
  end

  tutor = Tutor.find_or_create_by!(learner: learner) do |t|
    t.bio          = nil
    t.rating_avg   = 0
    t.rating_count = 0
  end

  visit new_login_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'

  @current_learner = learner
  @current_tutor   = tutor
end

# Temporary step definition (to be deleted later)
Given('the following tutor session exists:') do |table|
  table.hashes.each do |row|
    subj = Subject.find_by!(name: row['subject'])
    tutor = Tutor.find_by!(learner: @current_learner)
    # tutee = Learner.find_by!(first_name: 'Jane', last_name: 'Doe')

    @current_session = TutorSession.find_or_create_by!(
      tutor: tutor,
      subject: subj,
      start_at: Time.iso8601(row['start_at']),
      end_at: Time.iso8601(row['end_at'])
    ) do |s|
      s.capacity = row['capacity'].to_i
      s.status = row['status']
    end

    # SessionAttendee.find_or_create_by!(
    #   tutor_session: @current_session,
    #   learner: tutee
    # ) do |a|
    #   a.attended = nil
    #   a.feedback_submitted = false
    #   a.cancelled = false
    # end
  end
end

Given('I am on the "Session Details" page for the session at {string}') do |start_time|
  start_at = Time.iso8601(start_time)
  session = TutorSession.find_by!(start_at: start_at)
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

Then('the learner\'s attendance for the session should be set to {string}') do |bool|
  attended = (bool == 'true')
  current_attendee = SessionAttendee.find_by!(session: @current_session, learner: @current_learner)
  expect(current_attendee.attended).to eq(attended)
end

Then('I should not see the {string} option') do |radio|
    expect(page).not_to have_field(radio)
end
