class Admin::TutorsController < ApplicationController
  before_action :require_admin

  def index
  end

  def destroy
    @tutor = Tutor.find(params[:id])
    @tutor.destroy
    redirect_to admin_tutors_path, notice: "Tutor privilege revoked"
  end
end

