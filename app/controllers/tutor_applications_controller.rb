class TutorApplicationsController < ApplicationController
  def new
    @tutor_application = TutorApplication.new
  end
end
