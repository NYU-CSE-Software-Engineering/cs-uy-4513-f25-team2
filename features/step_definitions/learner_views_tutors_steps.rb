# i believe this was written in another step file
Given('I am a signed-in learner') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('the following tutors exist:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I am on the {string} page') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

When('I press on {string}') do |string|
  click_link string
end

Then('I am on the tutor's profile page') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see {string}') do |string|
  expect(page).to have_content(text)
end