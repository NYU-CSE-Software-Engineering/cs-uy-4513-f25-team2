When('I click {string} for the upcoming sessions starting at {string}') do |_text, start_time|
  start_str = Time.iso8601(start_time)

  within('.upcoming-sessions') do
    session_li = page.find('li.session', text: start_str.to_s)
    within(session_li) do
      click_link 'Cancel'
    end
  end
end


Given('the following session exists for another tutor:') do |table|
  other_learner = Learner.find_or_create_by!(email: 'other_learner@example.com') do |l|
    l.password   = 'password123'
    l.first_name = 'Other'
    l.last_name  = 'Learner'
  end

  other_tutor = Tutor.find_or_create_by!(learner: other_learner)

  table.hashes.each do |row|
    subject = Subject.find_or_create_by!(name: row['subject'])

    @other_session = TutorSession.create!(
      tutor:    other_tutor,
      subject:  subject,
      start_at: Time.iso8601(row['start_at']),
      end_at:   Time.iso8601(row['end_at']),
      capacity: row['capacity'].to_i,
      status:   row['status']
    )
  end
end


When("I attempt to cancel that other tutor's booking directly") do
  visit cancel_tutor_session_path(@other_session)
end

When("I confirm the cancellation") do
  click_button 'Yes'
end