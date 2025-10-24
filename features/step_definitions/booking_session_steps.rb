require 'time'
require 'securerandom'

<<<<<<< HEAD
Given('I am a signed-in user') do
  @current_learner ||= Learner.find_or_create_by!(email: "mia.patel@example.com") do |l|
    l.password   = "password123"
    l.first_name = "Mia"
    l.last_name  = "Patel"
  end
end

Given('I am on the "Find a Session" page') do
  visit slot_search_path
=======
Given('I am a signed-in learner') do
  email    = "mia-patel@example.com"
  password = "password123"

  @current_learner ||= Learner.find_or_create_by!(email: email) do |l|
    l.password   = password
    l.first_name = "Mia"
    l.last_name  = "Patel"
  end

  visit new_login_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'
end

Given('I am on the "Find a Session" page') do
  visit session_search_path
>>>>>>> main
  expect(page).to have_content("Find a Session")
end

Given('the subject {string} exists') do |subject_name|
  Subject.find_or_create_by!(name: subject_name) do |s|
    s.code = subject_name.parameterize.upcase.first(6)
    s.description = "#{subject_name} subject"
  end
end

<<<<<<< HEAD
Given('the following tutors and slots exist:') do |table|
=======
Given('the following tutors and sessions exist:') do |table|
>>>>>>> main
  table.hashes.each do |row|
    subj = Subject.find_by!(name: row['subject'])

    names = row['tutor_name'].to_s.strip.split
    first = names[0..-2].join(' ').presence || names.first
    last  = names.last
<<<<<<< HEAD

    tutor = Tutor.find_or_create_by!(first_name: first, last_name: last) do |t|
      t.email = "#{first.downcase.gsub(/\s+/,'_')}.#{last.downcase}@example.com"
      t.password = "password123"
      t.bio = nil
      t.qualifications = nil
      t.photo_url = nil
      t.rating_avg = 0
      t.rating_count = 0
    end

    Teach.find_or_create_by!(tutor: tutor, subject: subj)

    AvailabilitySlot.find_or_create_by!(
      tutor: tutor,
      start_at: Time.iso8601(row['slot_start']),
      end_at:   Time.iso8601(row['slot_end'])
    ) do |slot|
      slot.capacity = row['capacity'].to_i
      slot.recurrence_rule = nil
=======
    tutor_learner = Learner.find_or_create_by!(email: "#{first.downcase.gsub(/\s+/,'_')}.#{last.downcase}@example.com") do |l|
      l.password   = "password123"
      l.first_name = first
      l.last_name  = last
    end
    tutor = Tutor.find_or_create_by!(learner: tutor_learner)

    Teach.find_or_create_by!(tutor: tutor, subject: subj)

    Session.find_or_create_by!(
      tutor: tutor,
      subject: subj,
      start_at: Time.iso8601(row['session_start']),
      end_at:   Time.iso8601(row['session_end'])
    ) do |s|
      s.capacity     = row['capacity'].to_i
      s.status       = 'scheduled'
      s.meeting_link = "https://example.org/meet/#{SecureRandom.hex(3)}"
>>>>>>> main
    end
  end
end

Given('I am learner {string} with no upcoming sessions') do |learner_name|
  first, last = (learner_name.split(' ', 2) + [nil]).take(2)
  email = "#{learner_name.parameterize}@example.com"
  @current_learner = Learner.find_or_create_by!(email: email) do |l|
    l.password   = "password123"
    l.first_name = first || learner_name
    l.last_name  = last
  end
end

Given('I am learner {string} who has an existing session with tutor {string} from {string} to {string} in {string}') do |learner_name, tutor_name, start_iso, end_iso, subject_name|
  # Ensure learner
  first, last = (learner_name.split(' ', 2) + [nil]).take(2)
  email = "#{learner_name.parameterize}@example.com"
  @current_learner = Learner.find_or_create_by!(email: email) do |l|
    l.password   = "password123"
    l.first_name = first || learner_name
    l.last_name  = last
  end

  # Ensure subject
  subj = Subject.find_or_create_by!(name: subject_name) do |s|
    s.code = subject_name.parameterize.upcase.first(6)
    s.description = "#{subject_name} subject"
  end

  # Ensure tutor
  tnames = tutor_name.split
<<<<<<< HEAD
  tutor  = Tutor.find_or_create_by!(first_name: tnames[0..-2].join(' ').presence || tnames.first, last_name: tnames.last) do |t|
    t.email = "#{tnames[0].downcase}.#{tnames[-1].downcase}@example.com"
    t.password = "password123"
  end

  Teach.find_or_create_by!(tutor: tutor, subject: subj)

  # Ensure slot matching the existing session
  start_t = Time.iso8601(start_iso)
  end_t   = Time.iso8601(end_iso)
  slot = AvailabilitySlot.find_or_create_by!(tutor: tutor, start_at: start_t, end_at: end_t) do |as|
    as.capacity = 10
    as.recurrence_rule = nil
  end

  # Ensure session & attendee row
  session = Session.find_or_create_by!(availability_slot: slot) do |s|
    s.tutor        = tutor
    s.subject      = subj
    s.start_at     = slot.start_at
    s.end_at       = slot.end_at
    s.status       = 'scheduled'
    s.capacity     = slot.capacity
    s.meeting_link = "https://example.org/meet/#{SecureRandom.hex(3)}"
  end

  SessionsAttendee.find_or_create_by!(session: session, learner: @current_learner) do |sa|
    sa.joined_at = Time.now.utc
    sa.attended  = false
    sa.feedback_submitted = false
=======
  tfirst = tnames[0..-2].join(' ').presence || tnames.first
  tlast  = tnames.last
  tutor_learner = Learner.find_or_create_by!(email: "#{tfirst.downcase.gsub(/\s+/,'_')}.#{tlast.downcase}@example.com") do |l|
    l.password   = "password123"
    l.first_name = tfirst
    l.last_name  = tlast
  end
  tutor = Tutor.find_or_create_by!(learner: tutor_learner)
  Teach.find_or_create_by!(tutor: tutor, subject: subj)

  # Ensure the existing session
  start_t = Time.iso8601(start_iso)
  end_t   = Time.iso8601(end_iso)
  ses = Session.find_or_create_by!(tutor: tutor, subject: subj, start_at: start_t, end_at: end_t) do |s|
    s.capacity     = 3
    s.status       = 'scheduled'
    s.meeting_link = "https://example.org/meet/#{SecureRandom.hex(3)}"
  end

  # Ensure the attendee row
  SessionAttendee.find_or_create_by!(session: ses, learner: @current_learner) do |sa|
    sa.attended            = false
    sa.feedback_submitted  = false
    sa.cancelled           = false
>>>>>>> main
  end
end

When('I choose subject {string}') do |subject|
  fill_in 'subject', with: subject
end

When('I enter start {string} and end {string}') do |start_at, end_at|
  fill_in 'start_at', with: start_at
  fill_in 'end_at',   with: end_at
end

When('I run the search') do
  click_button 'Search'
  expect(page).to have_content("Search Results")
end

<<<<<<< HEAD
When('I select the slot for tutor {string} from {string} to {string}') do |tutor_name, start_iso, end_iso|
=======
When('I select the session for tutor {string} from {string} to {string}') do |tutor_name, start_iso, end_iso|
>>>>>>> main
  label = "Select #{tutor_name} #{Time.iso8601(start_iso).utc.iso8601}–#{Time.iso8601(end_iso).utc.iso8601}"
  expect(page).to have_button(label)
  click_button(label)
  expect(page).to have_content("Booking")
end

When('I confirm the booking') do
  click_button('Confirm Booking') if page.has_button?('Confirm Booking')
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end