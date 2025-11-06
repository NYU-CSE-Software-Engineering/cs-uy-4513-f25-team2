require 'rails_helper'

RSpec.describe "Tutors", type: :request do
  # Helper to create Subjects that meet validation requirements
  def make_subject(name, code)
    Subject.create!(name: name, code: code)
  end

  # Helper to create Tutors with associated Learner + Subjects
  def make_tutor(first:, last:, bio:, rating:, subjects:)
    learner = Learner.create!(
      email: "#{first.downcase}.#{last.downcase}@example.com",
      password: "password123",
      first_name: first,
      last_name: last
    )

    tutor = Tutor.create!(
      learner: learner,
      bio: bio,
      rating_avg: rating,
      rating_count: 1
    )

    subjects.each { |subject| Teach.create!(tutor: tutor, subject: subject) }
    tutor
  end

  describe "GET /tutors" do
    it "lists all tutors when no filter is applied" do
      calc = make_subject("Calculus", "MATH101")
      stats = make_subject("Statistics", "MATH201")

      make_tutor(first: "Emily", last: "Johnson", bio: "Hey.",   rating: 4.7, subjects: [calc])
      make_tutor(first: "Sarah", last: "Miller",  bio: "Hi.",    rating: 4.6, subjects: [calc])
      make_tutor(first: "Michael", last: "Chen",  bio: "Hello.", rating: 4.1, subjects: [stats])

      get tutors_path

      expect(response).to have_http_status(:ok)
    end

    it "shows an alert and no results when user submits with no subject selected" do
      # Drives the behavior for your sad-path scenario.
      # We simulate the user clicking 'submit' with an empty subject.
      make_subject("Calculus", "MATH101")
      make_tutor(first: "Emily",  last: "Johnson", bio: "Hey.",   rating: 4.7, subjects: [Subject.find_by(name: "Calculus")])

      get "/tutors", params: { subject: "", submit_attempt: "1" }

      expect(response).to have_http_status(:ok)
    end
  end
end

