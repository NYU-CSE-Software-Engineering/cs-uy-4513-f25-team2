require 'rails_helper'
require 'cgi'

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

    it "filters tutors by subject name" do
      calc = make_subject("Calculus", "MATH101")
      stats = make_subject("Statistics", "MATH201")

      emily   = make_tutor(first: "Emily", last: "Johnson", bio: "Hey.",   rating: 4.7, subjects: [calc])
      sarah   = make_tutor(first: "Sarah", last: "Miller",  bio: "Hi.",    rating: 4.6, subjects: [calc])
      michael = make_tutor(first: "Michael", last: "Chen",  bio: "Hello.", rating: 4.1, subjects: [stats])

      get tutors_path, params: { subject: "Calculus" }

      expect(response).to have_http_status(:ok)
      expect(assigns(:tutors)).to match_array([emily, sarah])
      expect(assigns(:tutors)).not_to include(michael)
    end
  end

  describe "GET /tutors/:id" do
    it "shows a tutor profile with key details" do
      stats = make_subject("Statistics", "MATH201")
      tutor = make_tutor(first: "Michael", last: "Chen", bio: "Hello.", rating: 4.1, subjects: [stats])

      get tutors_path(tutor)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /tutors/:id/edit" do
    let(:learner) do
      Learner.create!(
        email: "mia.patel@example.com",
        password: "password123",
        first_name: "Mia",
        last_name: "Patel"
      )
    end
    let(:tutor) { Tutor.create!(learner: learner, bio: "Hi, I'm Mia!") }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(learner)
    end

    it "redirects to login when not signed in as a tutor" do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(nil)

      get edit_tutor_path(tutor)
      expect(response).to redirect_to(new_login_path)
    end

    it "shows the update profile form for the logged-in tutor" do
      get edit_tutor_path(tutor)
      expect(response).to have_http_status(:ok)
    end

    it "does not allow editing another tutor's profile" do
      learner2 = Learner.create!(
        email: "john_smith@example.com",
        password: "password123",
        first_name: "John",
        last_name: "Smith"
      )
      tutor2 = Tutor.create!(learner: learner2, bio: "Hi, I'm another tutor.")
      
      get edit_tutor_path(tutor2)
      expect(response).to redirect_to(home_path)
      expect(flash[:alert]).to include("You are not authorized to edit this profile")
    end
  end

  describe "PATCH /tutors/:id" do
    let(:learner) do
      Learner.create!(
        email: "mia.patel@example.com",
        password: "password123",
        first_name: "Mia",
        last_name: "Patel"
      )
    end
    let(:tutor) { Tutor.create!(learner: learner, bio: "Hi, I'm Mia!") }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(learner)
    end

    it "redirects to login when not signed in as a tutor" do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(nil)

      patch tutor_path(tutor), params: { tutor: { bio: "Hi! This is my new bio!" } }
      expect(response).to redirect_to(new_login_path)
    end

    context "when updating bio with new information" do
      it "successfully updates the bio" do
        patch tutor_path(tutor), params: { tutor: { bio: "Hi! This is my new bio!" } }
        expect(response).to redirect_to(edit_tutor_path(tutor))
        expect(flash[:notice]).to eq("Changes saved")

        tutor.reload
        expect(tutor.bio).to eq("Hi! This is my new bio!")
      end
    end

    context "when updating bio with no changes" do
      it "shows a message indicating no changes were made" do
        patch tutor_path(tutor), params: { tutor: { bio: "Hi, I'm Mia!" } }
        expect(response).to redirect_to(edit_tutor_path(tutor))
        expect(flash[:notice]).to eq("No changes made")

        tutor.reload
        expect(tutor.bio).to eq("Hi, I'm Mia!")
      end
    end

    context "when updating bio to be empty" do
      it "successfully updates the bio to be empty" do
        patch tutor_path(tutor), params: { tutor: { bio: "" } }
        expect(response).to redirect_to(edit_tutor_path(tutor))
        expect(flash[:notice]).to eq("Changes saved")

        tutor.reload
        expect(tutor.bio).to eq("")
      end
    end

    context "when bio exceeds character limit" do
      it "does not allow bio to exceed 500 characters" do
        new_bio = 'a' * 501
        patch tutor_path(tutor), params: { tutor: { bio: new_bio } }
        expect(response).to have_http_status(:unprocessable_content)
        page_content = CGI.unescapeHTML(response.body)
        expect(page_content).to include("Character limit exceeded (500)")

        tutor.reload
        expect(tutor.bio).to eq("Hi, I'm Mia!")
      end
    end

    context "authorization" do
      it "does not allow updating another tutor's profile" do
        learner2 = Learner.create!(
          email: "john_smith@example.com",
          password: "password123",
          first_name: "John",
          last_name: "Smith"
        )
        tutor2 = Tutor.create!(learner: learner2, bio: "Hi, I'm another tutor.")
        
        patch tutor_path(tutor2), params: { tutor: { bio: "Hi! This is my new bio!" } }
        expect(response).to redirect_to(home_path)
        expect(flash[:alert]).to include("You are not authorized to edit this profile")

        tutor2.reload
        expect(tutor2.bio).to eq("Hi, I'm another tutor.")
      end
    end
  end
end

