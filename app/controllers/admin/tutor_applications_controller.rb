class Admin::TutorApplicationsController < ApplicationController
  before_action :require_admin

  def new
    @tutor_applications = TutorApplication.where(status: "pending").includes(:learner)
  end

  def approve
    application = TutorApplication.find(params[:id])
    Tutor.create!(learner: application.learner)
    application.update!(status: "approved")
    redirect_to new_admin_tutor_application_path, notice: "Application approved successfully"
  end
end
