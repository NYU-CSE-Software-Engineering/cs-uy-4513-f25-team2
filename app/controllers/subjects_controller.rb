class SubjectsController < ApplicationController
  before_action :require_admin

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    if @subject.save
      redirect_to new_subject_path, notice: "Subject created: #{@subject.name} (#{@subject.code})"
    else
      flash.now[:alert] = 'Could not create subject'
      render :new, status: :unprocessable_content # 422
    end
  end

  private

  def subject_params
    params.require(:subject).permit(:name, :code, :description)
  end
end