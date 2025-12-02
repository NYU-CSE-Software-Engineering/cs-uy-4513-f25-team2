Given ('the following tutor applications exist:') do |table|
  table.hashes.each do |row|
    learner_first, learner_last = row['learner'].split(' ', 2)
    learner = Learner.find_by!(first_name: learner_first, last_name: learner_last)

    TutorApplication.find_or_create_by!(
      learner: learner,
      reason: row['reason']
    ) do |ta|
      ta.status = 'Pending'
    end
  end
end

Given('I am on the "Pending Tutor Applications" page') do
  visit pending_tutor_applications_path
end

When('I select {string} from the dropdown for {string}') do |status, learner_name|
  learner_first, learner_last = learner_name.split(' ', 2)
  learner = Learner.find_by!(first_name: learner_first, last_name: learner_last)
  application = TutorApplication.find_by!(learner: learner)

  within("#application_container_#{application.id}") do
    select status
  end
end

When('I press {string} for {string}') do |string, learner_name|
  learner_first, learner_last = learner_name.split(' ', 2)
  learner = Learner.find_by!(first_name: learner_first, last_name: learner_last)
  application = TutorApplication.find_by!(learner: learner)

  within("#application_container_#{application.id}") do
    click_button string
  end
end

Then('the application status for {string} should be {string}') do |learner_name, status|
  learner_first, learner_last = learner_name.split(' ', 2)
  learner = Learner.find_by!(first_name: learner_first, last_name: learner_last)
  application = TutorApplication.find_by!(learner: learner)
  expect(application.status).to eq(status)
end

Then(/"([^"]*)" should (not )?be a tutor/) do |learner_name, not_be|
  learner_first, learner_last = learner_name.split(' ', 2)
  learner = Learner.find_by!(first_name: learner_first, last_name: learner_last)
  if not_be
    expect(learner.tutor).to be_nil
  else
    expect(learner.tutor).to be_present
  end
end

Then(/I should (not )?see a tutor application for "([^"]*)"/) do |not_see, learner_name|
  learner_first, learner_last = learner_name.split(' ', 2)
  learner = Learner.find_by!(first_name: learner_first, last_name: learner_last)
  application = TutorApplication.find_by!(learner: learner)
  if not_see
    expect(page).not_to have_css("#application_container_#{application.id}")
  else
    expect(page).to have_css("#application_container_#{application.id}")
  end
end

Then('I should not see any tutor applications') do
  expect(page).not_to have_css('tr.application-row')
end