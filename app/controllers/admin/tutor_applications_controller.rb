class Admin::TutorApplicationsController < ApplicationController
  before_action :require_admin

  def pending
    @tutor_applications = TutorApplication.where(status: "pending").includes(:learner)
  end

  def approve
    application = TutorApplication.find(params[:id])
    Tutor.create!(learner: application.learner)
    application.update!(status: "approved")
    redirect_to admin_tutor_applications_pending_path, notice: "Application approved successfully"
  end
end
