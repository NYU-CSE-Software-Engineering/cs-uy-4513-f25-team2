class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_learner, :current_admin

  private

  def current_learner
    @current_learner ||= Learner.find_by(id: session[:learner_id])
  end

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end

  def require_admin
    return if current_admin
    redirect_to new_login_path, alert: 'Please log in as admin'
  end
end