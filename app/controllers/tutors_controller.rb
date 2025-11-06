class TutorsController < ApplicationController
  def index
    if params[:subject].present?
      subject = Subject.find_by(name: params[:subject])
      @tutors = subject ? subject.tutors : Tutor.none
    else
      @tutors = Tutor.all
    end
  end
end
