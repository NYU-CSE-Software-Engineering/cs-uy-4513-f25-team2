class TutorsController < ApplicationController
  def index
    @tutors = Tutor.includes(:subjects).all
  end
end
