class Admin::TutorsController < ApplicationController
  before_action :require_admin

  def index
    @tutors = Tutor.includes(:learner).all
  end

  def destroy
    @tutor = Tutor.find(params[:id])
    @tutor.destroy
    redirect_to admin_tutors_path, notice: "Tutor privilege revoked"
  end
end

