class LearnersController < ApplicationController
  def new
    @learner = Learner.new
  end

  def create
    email    = params.dig(:learner, :email)    || params[:email]
    password = params.dig(:learner, :password) || params[:password]
    @learner = Learner.new(email: email.to_s.strip, password: password.to_s)

    if @learner.save
      redirect_to new_login_path, notice: 'Account Created!'
    else
      @errors = @learner.errors.full_messages
      render :new, status: :unprocessable_content # 422
    end
  end
end