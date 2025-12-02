class TutorApplicationsController < ApplicationController
  def new
    @tutor_application = TutorApplication.new
  end

  def create
    # build_tutor_application is a method from Rails’ has_one association in the Learner model. It builds a new TutorApplication object for the current_learner
    app = current_learner.build_tutor_application(tutor_application_params)
    app.status = "pending"
    app.save!
  end

  private
  def tutor_application_params
    params.require(:tutor_application).permit(:reason)
  end
end
