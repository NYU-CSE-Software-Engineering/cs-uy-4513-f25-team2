class LearnersController < ApplicationController
  def new
    @learner = Learner.new
  end

  def create
    @learner = Learner.new(learner_params)

    if @learner.save
      redirect_to new_login_path, notice: 'Account Created!'
    else
      @errors = @learner.errors.full_messages
      render :new, status: :unprocessable_content
    end
  end

  private

  def learner_params
    params.require(:learner).permit(:email, :password, :password_confirmation)
  end
end