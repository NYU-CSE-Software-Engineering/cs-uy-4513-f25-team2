class TutorApplicationsController < ApplicationController
  before_action :require_learner

  def new
    # grabs the current learners application status to decide what to render on the page
    tutor_app = current_learner&.tutor_application
    @tutor_application_status =
      if tutor_app.nil?
        :none       # no application exists
      elsif tutor_app.status == "pending"
        :pending    # application is pending
      elsif tutor_app.status == "approved"
        :approved   # application is approved
      end
  end

  def create
    # build_tutor_application is a method from Rails’ has_one association in the Learner model. It builds a new TutorApplication object for the current_learner
    app = current_learner.build_tutor_application(tutor_application_params)
    app.status = "pending"
    if app.save
      flash[:notice] = "Application Sent!"
    else
      flash[:alert] = "Could Not Apply"
    end
    redirect_to root_path
  end

  private
  def tutor_application_params
    params.require(:tutor_application).permit(:reason)
  end
end
