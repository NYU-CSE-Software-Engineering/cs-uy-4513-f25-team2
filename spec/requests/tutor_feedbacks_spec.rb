require 'rails_helper'

RSpec.describe 'Tutor::Feedbacks', type: :request do
  let(:tutor_learner) do
    Learner.create!(
      email: 'tutor@example.com',
      password: 'password123',
      first_name: 'Test',
      last_name: 'Tutor'
    )
  end

  let(:tutor) do
    Tutor.create!(learner: tutor_learner, bio: 'Math & CS')
  end

  # Simple helper to simulate logging in as a tutor
  def log_in_as_tutor
    allow_any_instance_of(ApplicationController).to receive(:current_learner).and_return(tutor_learner)
    allow_any_instance_of(ApplicationController).to receive(:current_tutor).and_return(tutor)
  end

  describe 'GET /tutor/feedbacks' do
    it 'redirects to login when not signed in' do
      get tutor_feedbacks_path
      expect(response).to redirect_to(new_login_path)
    end

    it 'shows all feedback for the current tutor' do
      subject = Subject.create!(name: 'Calculus', code: 'MATH101')
      
      session1 = TutorSession.create!(
        tutor: tutor,
        subject: subject,
        start_at: 5.days.ago,
        end_at: 4.days.ago,
        capacity: 5,
        status: 'completed'
      )
      
      session2 = TutorSession.create!(
        tutor: tutor,
        subject: subject,
        start_at: 3.days.ago,
        end_at: 2.days.ago,
        capacity: 5,
        status: 'completed'
      )

      learner1 = Learner.create!(
        email: 'learner1@example.com',
        password: 'password123',
        first_name: 'Jane',
        last_name: 'Doe'
      )

      learner2 = Learner.create!(
        email: 'learner2@example.com',
        password: 'password123',
        first_name: 'John',
        last_name: 'Doe'
      )

      Feedback.create!(
        tutor_session: session1,
        learner: learner1,
        tutor: tutor,
        score: 5,
        comment: 'Very clear explanations!'
      )

      Feedback.create!(
        tutor_session: session2,
        learner: learner2,
        tutor: tutor,
        score: 4,
        comment: 'Helpful but a bit too fast.'
      )

      log_in_as_tutor
      get tutor_feedbacks_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Very clear explanations!')
      expect(response.body).to include('Helpful but a bit too fast.')
      expect(response.body).to include('Average Rating:')
      expect(response.body).to include('4.5')
      expect(response.body).to include('Total Reviews:')
      expect(response.body).to include('2')
    end

    it 'filters feedback by subject' do
      calc = Subject.create!(name: 'Calculus', code: 'MATH101')
      chem = Subject.create!(name: 'Chemistry', code: 'CHEM201')

      calc_session = TutorSession.create!(
        tutor: tutor,
        subject: calc,
        start_at: 5.days.ago,
        end_at: 4.days.ago,
        capacity: 5,
        status: 'completed'
      )

      chem_session = TutorSession.create!(
        tutor: tutor,
        subject: chem,
        start_at: 3.days.ago,
        end_at: 2.days.ago,
        capacity: 5,
        status: 'completed'
      )

      learner = Learner.create!(
        email: 'learner@example.com',
        password: 'password123',
        first_name: 'Jane',
        last_name: 'Doe'
      )

      Feedback.create!(
        tutor_session: calc_session,
        learner: learner,
        tutor: tutor,
        score: 5,
        comment: 'Calculus feedback'
      )

      Feedback.create!(
        tutor_session: chem_session,
        learner: learner,
        tutor: tutor,
        score: 4,
        comment: 'Chemistry feedback'
      )

      log_in_as_tutor
      get tutor_feedbacks_path, params: { subject: 'Calculus' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Calculus feedback')
      expect(response.body).not_to include('Chemistry feedback')
    end

    it 'shows pagination when there are more than 10 feedback entries' do
      subject = Subject.create!(name: 'Math', code: 'MATH101')

      12.times do |i|
        start_time = Time.zone.now - (i * 2).hours - 1.hour
        end_time = start_time + 1.hour

        session = TutorSession.create!(
          tutor: tutor,
          subject: subject,
          start_at: start_time,
          end_at: end_time,
          capacity: 5,
          status: 'completed'
        )

        learner = Learner.create!(
          email: "learner#{i}@example.com",
          password: 'password123',
          first_name: "L#{i}",
          last_name: 'User'
        )

        Feedback.create!(
          tutor_session: session,
          learner: learner,
          tutor: tutor,
          score: 3 + (i % 3),
          comment: "Comment #{i}"
        )
      end

      log_in_as_tutor
      get tutor_feedbacks_path

      expect(response).to have_http_status(:ok)
      # Should only show 10 items on first page
      expect(response.body.scan(/Comment \d+/).length).to eq(10)
    end

    it 'prevents viewing another tutor\'s feedback' do
      other_tutor_learner = Learner.create!(
        email: 'other_tutor@example.com',
        password: 'password123',
        first_name: 'Other',
        last_name: 'Tutor'
      )
      other_tutor = Tutor.create!(learner: other_tutor_learner, bio: 'Chemistry')

      subject = Subject.create!(name: 'Math', code: 'MATH101')
      session = TutorSession.create!(
        tutor: other_tutor,
        subject: subject,
        start_at: 5.days.ago,
        end_at: 4.days.ago,
        capacity: 5,
        status: 'completed'
      )

      learner = Learner.create!(
        email: 'learner@example.com',
        password: 'password123',
        first_name: 'Jane',
        last_name: 'Doe'
      )

      Feedback.create!(
        tutor_session: session,
        learner: learner,
        tutor: other_tutor,
        score: 5,
        comment: 'Other tutor feedback'
      )

      log_in_as_tutor
      get tutor_feedbacks_path, params: { tutor_id: other_tutor.id }

      expect(response).to redirect_to(tutor_feedbacks_path)
      follow_redirect!
      expect(flash[:alert]).to eq('Access denied')
    end

    it 'shows empty state when tutor has no feedback' do
      log_in_as_tutor
      get tutor_feedbacks_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('No feedback yet')
    end
  end
end
