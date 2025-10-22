Given("I am on the sign-up page") do
  visit new_signup_path
end

When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I press {string}") do |button|
  click_button button
end

Then("I should see a message {string}") do |message|
  expect(page).to have_content(message)
end

Then("I should be redirected to login page") do
  expect(current_path).to eq(new_login_path)
end

Then("I should see an error message indicating a password is required") do
  expect(page).to have_content("Password can't be blank")
end

Then("I should see an error message indicating an email is required") do
  expect(page).to have_content("Email can't be blank")
end

Then("I should see an error message indicating an email is required and a password is required") do
  expect(page).to have_content("Email can't be blank")
  expect(page).to have_content("Password can't be blank")
end

Given("I am on the login page") do
  visit new_login_path
end

Given("an account exists for {string} with password {string}") do |email, password|
  User.create!(email: email, password: password)
end

Then("I should be redirected to the dashboard page") do
  expect(current_path).to eq(dashboard_path)
end

Then("I should see an error message indicating email or password is incorrect") do
  expect(page).to have_content("Invalid email or password")
end

Given("I am logged in as {string}") do |email|
  user = User.find_by(email: email) || User.create!(email: email, password: "password")
  visit new_login_path
  fill_in "Email", with: user.email
  fill_in "Password", with: "password"
  click_button "Log in"
  expect(page).to have_current_path(dashboard_path)
end

Then("I should be redirected to the login page") do
  expect(current_path).to eq(new_login_path)
end

