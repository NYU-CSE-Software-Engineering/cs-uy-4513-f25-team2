# features/step_definitions/feedback_steps.rb
Given("I am a signed-in learner") do
  # Create a learner in the test DB
  @learner = Learner.create!(
    email: "learner@example.com",
    password: "password123"
    first_name: "Exa",
    last_name: "Mine",
  )
end

# ---------- Domain setup ----------

Given("I have completed a tutoring session with {string}") do |tutor_name|
  @tutor = Tutor.find_or_create_by!(name: tutor_name, email: "tutor@example.com")
  @session = Session.create!(learner: @learner, tutor: @tutor, completed: true)
end

Given("I have a completed session with {string} where I was marked present") do |tutor_name|
  step %{I am a signed-in learner}
  @tutor = Tutor.find_or_create_by!(name: tutor_name, email: "tutor@example.com")
  @session = Session.create!(learner: @learner, tutor: @tutor, completed: true)
  SessionsAttendee.create!(session: @session, learner: @learner, attended: true)
end

Given("I have a completed session with {string} where I was marked absent") do |tutor_name|
  step %{I am a signed-in learner}
  @tutor = Tutor.find_or_create_by!(name: tutor_name, email: "tutor@example.com")
  @session = Session.create!(learner: @learner, tutor: @tutor, completed: true)
  SessionsAttendee.create!(session: @session, learner: @learner, attended: false)
end


When("I navigate to the feedback form for {string}") do |tutor_name|
  visit learner_sessions_path(@learner) # adjust if we change the path
  expect(page).to have_content(tutor_name)

  # Click the UI element that opens the feedback form
  # Use link or button depending on your view:
  if page.has_link?("Leave Feedback")
    click_link "Leave Feedback", match: :first
  else
    click_button "Leave Feedback", match: :first
  end

  expect(page).to have_content("Submit Feedback for #{tutor_name}")
end

Given("I am on the feedback page for {string}") do |tutor_name|
  visit new_feedback_path(session_id: @session.id)
  expect(page).to have_content("Submit Feedback for #{tutor_name}")
end

# ---------- Form interactions (scoped/specific to avoid overlap) ----------

When("I select a feedback rating of {string}") do |rating|
  # assumes radio buttons labelled 1..5
  choose(rating)
end

When("I fill the feedback comment with {string}") do |text|
  # make sure your textarea label or id is "Comment"
  fill_in "Comment", with: text
end

When("I submit the feedback form") do
  click_button "Submit Feedback"
end

Then("I should see a feedback notice {string}") do |message|
  expect(page).to have_content(message)
end

Then("the feedback button should be hidden") do
  expect(page).not_to have_link("Leave Feedback")
  expect(page).not_to have_button("Leave Feedback")
end
