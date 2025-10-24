# features/step_definitions/tutor_feedback_steps.rb
require 'time'

Given('I am a logged-in tutor') do
  @learner = Learner.create!(
    first_name: 'Test',
    last_name:  'Tutor',
    email:      'tutor@example.com',
    password:   'password'
  )
  @tutor = Tutor.create!(learner: @learner, bio: 'Math & CS', rating_avg: 0, rating_count: 0)

  visit login_path
  fill_in 'Email', with: @learner.email
  fill_in 'Password', with: 'password'
  click_button 'Log in'
end

Given('the following learners exist:') do |table|
  table.hashes.each do |row|
    Learner.create!(
      email:      row['email'],
      password:   row['password'],
      first_name: row['first_name'],
      last_name:  row['last_name']
    )
  end
end

Given('the following subjects exist:') do |table|
  table.hashes.each do |row|
    Subject.create!(name: row['name'], code: row['code'])
  end
end

Given('the following sessions exist:') do |table|
  table.hashes.each do |row|
    subject = Subject.find_by!(name: row['subject'])
    Session.create!(
      tutor:        @tutor,
      subject:      subject,
      start_at:     Time.iso8601(row['start_at']),
      end_at:       Time.iso8601(row['end_at']),
      capacity:     5,
      status:       row['status'] || 'completed',
      meeting_link: 'https://meet.example/test'
    )
  end
end

Given('the following feedback exists:') do |table|
  table.hashes.each do |row|
    subject = Subject.find_by!(name: row['session'])
    session = Session.where(tutor: @tutor, subject: subject).order(:start_at).first
    learner = Learner.find_by!(email: row['learner_email'])
    Feedback.create!(
      session: session,
      learner: learner,
      tutor:   @tutor,
      score:   row['score'].to_i,
      comment: row['comment']
    )
  end
end

Given("I am on the Tutor Feedback page") do
  visit tutor_feedbacks_path
end

When('I view my feedback list') do
  visit tutor_feedbacks_path
end

When('I filter feedback by subject {string}') do |subject_name|
  if page.has_select?('Subject')
    select subject_name, from: 'Subject'
  end
  if page.has_button?('Apply Filters')
    click_button 'Apply Filters'
  end
end

Then('I should not see {string}') do |text|
  expect(page).not_to have_content(text)
end

Given('I am a tutor with no feedback yet') do
  @learner = Learner.create!(
    first_name: 'Empty',
    last_name:  'Tutor',
    email:      'empty_tutor@example.com',
    password:   'password'
  )
  @tutor = Tutor.create!(learner: @learner, bio: 'N/A', rating_avg: 0, rating_count: 0)

  visit login_path
  fill_in 'Email', with: @learner.email
  fill_in 'Password', with: 'password'
  click_button 'Log in'
end

When('I visit the Tutor Feedback page') do
  visit tutor_feedbacks_path
end

Given('another tutor exists') do
  other_learner = Learner.create!(
    first_name: 'Other',
    last_name:  'Tutor',
    email:      'other_tutor@example.com',
    password:   'password'
  )
  @other_tutor = Tutor.create!(learner: other_learner, bio: 'Chemistry', rating_avg: 0, rating_count: 0)
end

When('I try to access that tutor’s feedback page') do
  visit "#{tutor_feedbacks_path}?tutor_id=#{@other_tutor.id}"
end

Given('I have more than 10 feedback entries') do
  subject = Subject.first || Subject.create!(name: 'Temp', code: 'TEMP')
  12.times do |i|
    session = Session.create!(
      tutor:        @tutor,
      subject:      subject,
      start_at:     Time.zone.now - i.hours,
      end_at:       Time.zone.now - (i.hours - 1.hour),
      capacity:     5,
      status:       'completed',
      meeting_link: 'https://meet.example/test'
    )
    learner = Learner.create!(
      first_name: "L#{i}",
      last_name:  'User',
      email:      "l#{i}@example.com",
      password:   'password'
    )
    Feedback.create!(
      session: session,
      learner: learner,
      tutor:   @tutor,
      score:   3 + (i % 3),
      comment: "Comment #{i}"
    )
  end
end

Then('I should see only {int} feedback items displayed') do |n|
  expect(page).to have_css('.feedback-row', count: n)
end

Then('I should see pagination controls') do
  expect(page).to have_css('.pagination')
end
