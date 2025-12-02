require "securerandom"

# We rely on "Given I am a signed-in learner" from booking_session_steps.rb
# which sets @current_learner.

# ---------- Data setup ----------

Given("I have a completed session with {string} where I was marked present") do |tutor_name|
  learner = @current_learner
  raise "current_learner is nil – make sure Background has 'Given I am a signed-in learner'" if learner.nil?

  # Split tutor name like "Michael Chen"
  first, last = tutor_name.split(" ", 2)
  last ||= ""

  tutor_learner = Learner.find_or_create_by!(
    email: "#{first.downcase}.#{last.downcase}@example.com"
  ) do |l|
    l.password   = "password123"
    l.first_name = first
    l.last_name  = last
  end

  @tutor = Tutor.find_or_create_by!(learner: tutor_learner) do |t|
    t.bio          = "Test tutor"
    t.rating_avg   = 4.1
    t.rating_count = 45
  end

  subject = Subject.first || Subject.create!(name: "Statistics", code: "STAT101")

  @tutor_session = TutorSession.create!(
    tutor:    @tutor,
    subject:  subject,
    start_at: 2.days.ago,
    end_at:   2.days.ago + 1.hour,
    capacity: 5,
    status:   "Completed"
  )

  @attendee = SessionAttendee.create!(
    tutor_session: @tutor_session,
    learner:       learner,
    attended:      true
  )
end

Given("I have a completed session with {string} where I was marked absent") do |tutor_name|
  step %{I have a completed session with "#{tutor_name}" where I was marked present}
  @attendee.update!(attended: false)
end

# ---------- Navigation / UI steps ----------

When("I navigate to the feedback form for {string}") do |tutor_name|
  # For now, assume the feedback form is reached from the session's show page.
  # This matches the SessionsController routes: session_path(@tutor_session)
  visit session_path(@tutor_session)

  expect(page).to have_content(tutor_name)

  # Click whatever control opens the feedback form.
  if page.has_link?("Leave Feedback")
    click_link "Leave Feedback", match: :first
  elsif page.has_button?("Leave Feedback")
    click_button "Leave Feedback", match: :first
  end
end

When("I visit the session page for {string}") do |tutor_name|
  visit session_path(@tutor_session)
  expect(page).to have_content(tutor_name)
end

# ---------- Form interactions ----------

When("I select a rating of {string}") do |rating|
  # assumes radio buttons labelled 1..5
  choose(rating)
end

# NOTE: you already have generic steps:
#   And I fill in "Comment" with "Great tutor!"
#   And I press "Submit Feedback"
# from auth_steps / application_steps, so we don't re-define them here.

# ---------- Assertions ----------

Then("I should not see {string}") do |text|
  expect(page).not_to have_content(text)
end
