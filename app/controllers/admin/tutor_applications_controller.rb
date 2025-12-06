class Admin::TutorApplicationsController < ApplicationController
  before_action :require_admin

  def new
    @tutor_applications = TutorApplication.where(status: "pending").includes(:learner)
  end
end
