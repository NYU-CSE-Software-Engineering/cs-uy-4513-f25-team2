Given('I am a learner') do
  @learner = Learner.create!(
    first_name: 'Test',
    last_name: 'Learner',
    email: 'learner@example.com',
    password: 'password'
  )
end

Given('I am logged in as a learner') do
    step 'I am a learner'
    visit login_path
    fill_in 'Email', with: @learner.email
    fill_in 'Password', with: @learner.password
    click_button 'Log in'
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

When('I submit my reason') do
    fill_in 'Reason', with: 'I want to help students learn effectively.'
    click_button 'Submit Application'
end

Then('I should see a message that my application was submitted') do
    expect(page).to have_content('Your application has been submitted')
end

Given('I am a tutor') do
  @tutor = Tutor.create!(
    first_name: 'Test',
    last_name: 'Tutor',
    email: 'tutor@example.com',
    password: 'password'
  )
end

Given('I am logged in as a tutor') do
    step 'I am a tutor'
    visit login_path
    fill_in 'Email', with: @tutor.email
    fill_in 'Password', with: @tutor.password
    click_button 'Log in'
end

Then('I should not see the {string} button') do |string|
    expect(page).not_to have_button(string)
end

Then('I should not see the {string} message') do |string|
    expect(page).not_to have_content(string)
end

Given('I have a pending application') do
    learner = Learner.find_by(email: @learner.email)
    PendingApplication.create!(learner: learner, reason: 'Testing reason')
end

Given('an admin has approved my application') do
    @learner = Learner.create!(
    email: 'learner@example.com',
    password: 'password',
    first_name: 'Test',
    last_name: 'Learner'
  )

  @tutor = Tutor.create!(
    learner: @learner,
    first_name: @learner.first_name,
    last_name: @learner.last_name
  )
end

When('I log in as a learner') do
  visit login_path
  fill_in 'Email', with: @learner.email
  fill_in 'Password', with: @learner.password
  click_button 'Log in'
end

Then('I should see tutor options available on my dashboard') do
    visit dashboard_path
    expect(page).to have_content('Book a Session')
end