Given('I am a Tutor') do
  @current_tutor ||= Tutor.find_or_create_by!(email: @current_learner.email) do |t|
    t.bio          = nil
    t.photo_url    = nil
    t.rating_avg   = 0
    t.rating_count = 0
  end
end

When('I visit the Settings page') do
    visit settings_path
end

Then('I should see the {string} button') do |string|
    expect(page).to have_button(string)
end

When('I click the {string} button') do |string|
    click_button(string)
end

Then('I should see the tutor application page') do
    expect(page).to have_content('Tutor Application')
end

Given('I visit the tutor application page') do
    visit tutor_application_path
end

Given('I enter reason {string}') do |string|
  fill_in 'Reason', with: string
end

Then('I should see a message that my application was submitted') do
  expect(page).to have_content('Your application has been submitted')
end

Then('I should not see the {string} button') do |string|
    expect(page).not_to have_button(string)
end

Then('I should not see the {string} message') do |string|
    expect(page).not_to have_content(string)
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Given('I have a pending application') do
    learner = Learner.find_by(email:  @current_learner.email)
    TutorApplication.find_or_create_by!(learner: learner, reason: 'Testing reason')
end

Given('an admin has approved my application') do
  @current_learner ||= Learner.find_or_create_by!(email: "mia.patel@example.com") do |l|
    l.password   = "password123"
    l.first_name = "Mia"
    l.last_name  = "Patel"
  end

  @current_tutor ||= Tutor.find_or_create_by!(email: @current_learner.email) do |t|
    t.bio          = nil
    t.photo_url    = nil
    t.rating_avg   = 0
    t.rating_count = 0
  end

  TutorApplication.find_by(learner: @current_learner)&.destroy
end

When('I sign-in as a learner') do
  visit login_path
  fill_in 'Email', with: @current_learner.email
  fill_in 'Password', with: @current_learner.password
  click_button 'Log in'
end
