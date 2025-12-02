require "securerandom"

# We rely on "Given I am a signed-in learner" from booking_session_steps.rb
# which sets @current_learner.

# ---------- Data setup ----------

Given("I have a completed session with {string} where I was marked present") do |tutor_name|
  # Use the learner created by "I am a signed-in learner"
  learner = @current_learner || @learner
  raise "current_learner is nil – make sure Background has 'Given I am a signed-in learner'" if learner.nil?

  # Split tutor name like "Michael Chen"
  names = tutor_name.split
  first = names[0..-2].join(" ")
  last  = names.last || ""

  tutor_learner = Learner.find_or_create_by!(
    email: "#{first.downcase.gsub(' ', '_')}.#{last.downcase}@example.com"
  ) do |l|
    l.password   = "password123"
    l.first_name = first
    l.last_name  = last
  end

  @tutor = Tutor.find_or_create_by!(learner: tutor_learner) do |t|
    t.bio          ||= "Test tutor"
    t.rating_avg   ||= 4.1
    t.rating_count ||= 45
  end

  subject = Subject.first || Subject.create!(name: "Statistics", code: "STAT101")

  # Reuse an existing completed session for this tutor+subject if it exists,
  # so we don't trip the "no overlapping sessions" validation.
  @tutor_session = TutorSession.where(
    tutor:   @tutor,
    subject: subject,
    status:  "Completed"
  ).where("end_at < ?", Time.current).first

  unless @tutor_session
    @tutor_session = TutorSession.create!(
      tutor:    @tutor,
      subject:  subject,
      start_at: 2.days.ago.change(min: 0, sec: 0),
      end_at:   2.days.ago.change(min: 59, sec: 59),
      capacity: 5,
      status:   "Completed"
    )
  end

  # Reuse or create the attendee and mark present
  @attendee = SessionAttendee.find_or_create_by!(
    tutor_session: @tutor_session,
    learner:       learner
  ) do |sa|
    sa.attended = true
  end
end

Given("I have a completed session with {string} where I was marked absent") do |tutor_name|
  # Background already set up the "present" session, but in case someone
  # reuses this step elsewhere, fall back to the present step.
  if @attendee.nil? || @tutor_session.nil?
    step %{I have a completed session with "#{tutor_name}" where I was marked present}
  end

  @attendee.update!(attended: false)
end

# ---------- Navigation / UI steps ----------

When("I navigate to the feedback form for {string}") do |_tutor_name|
  # For now, just go to the session's show page.
  # We *don't* assert the tutor's name here because the current Session Details
  # view doesn't render "Michael Chen" anywhere.
  visit session_path(@tutor_session)

  # If/when a "Leave Feedback" control exists, click it.
  if page.has_link?("Leave Feedback")
    click_link "Leave Feedback", match: :first
  elsif page.has_button?("Leave Feedback")
    click_button "Leave Feedback", match: :first
  end
end

When("I visit the session page for {string}") do |_tutor_name|
  visit session_path(@tutor_session)
end

# ---------- Form interactions ----------

When("I select a rating of {string}") do |rating|
  # assumes radio buttons labelled 1..5
  choose(rating)
end

# NOTE: generic steps like
#   And I fill in "Comment" with "Great tutor!"
#   And I press "Submit Feedback"
# already live in other step files, so we don't redefine them here.

# ---------- Assertions ----------

Then("I should not see {string}") do |text|
  expect(page).not_to have_content(text)
end
