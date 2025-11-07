class TutorsController < ApplicationController
  def index
    if(params[:subject].present?)
      subject = Subject.find_by(name: params[:subject])
      if subject
        @tutors = subject.tutors
      else
        flash.now[:alert] = "No subject to filter"
        @tutors = []
      end
    else
      @tutors = Tutor.all
    end
  end

  def show
    @tutor = Tutor.find(params[:id])
  end
end
