# features/step_definitions/feedback_steps.rb
Given("I am a logged-in learner") do
  @learner = Learner.find_or_create_by!(email: "learner@example.com") do |l|
    l.password = "password123"
    l.first_name = "Exa"
    l.last_name = "Mine"
  end

  visit new_login_path
  fill_in "Email", with: @learner.email
  fill_in "Password", with: "password123"
  click_button "Log in"
end

Given("I have completed a tutoring session with {string}") do |tutor_name|
  # Create a tutor via its associated learner (Tutor has no name/email columns)
  tutor_learner = Learner.create!(
    email: "tutor_#{tutor_name.parameterize}@example.com",
    password: "password123",
    first_name: tutor_name,
    last_name: "Tutor"
  )

  @tutor = Tutor.create!(
    learner: tutor_learner,
    bio: "Test tutor"
  )

  # Create a completed tutor session in the past
  subject = Subject.first || Subject.create!(name: "Test Subject", code: "TEST")
  @session = TutorSession.create!(
    tutor: @tutor,
    subject: subject,
    start_at: 2.days.ago,
    end_at: 1.day.ago,
    capacity: 5,
    status: "completed"
  )

  # Link the current learner to that session
  SessionAttendee.create!(
    tutor_session: @session,
    learner: @learner,
    attended: true,
    feedback_submitted: false
  )
end

Given("I have a completed session with {string} where I was marked present") do |tutor_name|
  step %{I am a logged-in learner}

  # Find or update the existing SessionAttendee from the background step
  attendee = SessionAttendee.find_or_initialize_by(
    tutor_session: @session,
    learner: @learner
  )
  attendee.update!(attended: true, feedback_submitted: false)
end

Given("I have a completed session with {string} where I was marked absent") do |tutor_name|
  step %{I am a logged-in learner}

  # Find or update the existing SessionAttendee from the background step
  attendee = SessionAttendee.find_or_initialize_by(
    tutor_session: @session,
    learner: @learner
  )
  attendee.update!(attended: false, feedback_submitted: false)
end


When("I navigate to the feedback form for {string}") do |tutor_name|
  # Since the session is in the past, visit the past sessions page
  visit past_learner_sessions_path
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

When("I select a rating of {string}") do |rating|
  # Select the feedback score radio button by its value/name
  find("input[name='feedback[score]'][value='#{rating}']", visible: :all).click
end

When('I visit the session page for {string}') do |tutor_name|
  visit session_path(@session)
end

Then("I should not see {string}") do |text|
  expect(page).not_to have_content(text)
end