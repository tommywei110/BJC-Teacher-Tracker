class MainController < ApplicationController
  before_action :require_admin, only: [:dashboard]

  def index
    if is_admin?
      redirect_to dashboard_path
    else
      redirect_to new_teacher_path
    end
  end

  def dashboard
    @unvalidated_teachers = Teacher.unvalidated.order(:created_at) || []
    @validated_teachers = Teacher.validated.order(:created_at) || []
    @courses = Teacher.validated.group(:course).order('count_all desc').limit(6).count
    @schools = School.validated.order(num_validated_teachers: :desc)
  end

  def logout
    session[:logged_in] = false
    redirect_to root_url
  end
end