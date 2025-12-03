Given("I am logged in as an admin") do
  email, password = 'admin@example.com', 'password123'
  Admin.find_or_create_by!(email: email) { |a| a.password = password }
  visit new_login_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'
end

Given('a learner {string} exists') do |email|
  Learner.find_or_create_by!(email: email) { |l| l.password = "password123" }
end

Given('the learner {string} is a tutor') do |email|
  learner = Learner.find_by!(email: email)
  Tutor.find_or_create_by!(learner: learner)
end

When('I visit the tutors management page') do
  visit admin_tutors_path
end

When('I revoke tutor privilege for {string}') do |email|
  learner = Learner.find_by!(email: email)
  tutor = Tutor.find_by!(learner: learner)
  within("li", text: email) do
    click_button "Revoke Privilege"
  end
end

Then('I should see a message that the tutor privilege was revoked') do
  expect(page).to have_content("Tutor privilege revoked")
end

Then('the learner {string} should no longer be a tutor') do |email|
  learner = Learner.find_by!(email: email)
  expect(Tutor.find_by(learner: learner)).to be_nil
end

