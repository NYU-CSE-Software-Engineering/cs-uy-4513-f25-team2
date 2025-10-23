# features/step_definitions/feedback_steps.rb
Given("I am a signed-in learner") do
  # Create a learner and sign in
  @learner = Learner.create!(
    email: "learner@example.com",
    password: "password123"
  )

  visit new_learner_session_path
  fill_in "Email", with: @learner.email
  fill_in "Password", with: @learner.password
  click_button "Log in"

  expect(page).to have_content("Dashboard").or have_content("Welcome")
end

Given("I have completed a tutoring session with {string}") do |tutor_name|
  @tutor = Tutor.create!(
    name: tutor_name,
    email: "tutor@example.com"
  )

  @session = Session.create!(
    learner: @learner,
    tutor: @tutor,
    completed: true
  )
end

When("I navigate to the feedback form for {string}") do |tutor_name|
  visit learner_sessions_path(@learner)
  expect(page).to have_content(tutor_name)

  click_link "Leave Feedback", match: :first

  expect(page).to have_content("Submit Feedback for #{tutor_name}")
end

Given("I am on the feedback page for {string}") do |tutor_name|
  visit new_feedback_path(session_id: @session.id)
  expect(page).to have_content("Submit Feedback for #{tutor_name}")
end

When("I select a rating of {string}") do |rating|
  # assumes rating radio buttons are labeled 1–5
  choose rating
end

When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I press {string}") do |button|
  click_button button
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

When("I sign in as tutor {string}") do |tutor_name|
  @tutor = Tutor.find_by(name: tutor_name) ||
            Tutor.create!(name: tutor_name, email: "tutor@example.com", password: "password")

  visit new_tutor_session_path
  fill_in "Email", with: @tutor.email
  fill_in "Password", with: @tutor.password
  click_button "Log in"

  expect(page).to have_content("Dashboard").or have_content("Welcome")
end

When("I visit the feedbacks index") do
  visit feedbacks_path
end

Then("I should see feedback from the learner for the session") do
  expect(page).to have_content(@learner.email).or have_content(@learner.first_name)
end
