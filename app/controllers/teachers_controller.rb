class TeachersController < ApplicationController
  before_action :sanitize_params, only: [:new, :create, :edit, :update]
  before_action :require_login, except: [:new, :create]
  before_action :require_admin, only: [:validate, :deny, :delete, :index]
  before_action :require_edit_permission, only: [:edit, :update]

  def index
    @all_teachers = Teacher.where(admin: false)
  end

  def new
    @teacher = Teacher.new
    @school = School.new
  end

  def create
    # TODO: This needs to be re-written.
    @school = School.new(school_params)
    # Find by email, but allow updating other info.
    @teacher = Teacher.find_by(email: teacher_params[:email])
    if @teacher
      # Exclude website from the school finder, so we can update an existing school.
      @school = School.find_or_create_by(name: school_params[:name], city: school_params[:city], state: school_params[:state])
      @school.website = school_params[:website]
      @school.save!
      @teacher.update(teacher_params)
      @teacher.school = @school
      @teacher.save!
      if @teacher.validated?
        TeacherMailer.welcome_email(@teacher).deliver_now
        TeacherMailer.form_submission(@teacher).deliver_now
        flash[:success] = "Thanks! We have updated your information. We have sent BJC info to #{@teacher.email}."
      else
        flash[:success] = "Thanks! We have updated your information."
      end
      redirect_to root_path
    else
      @school = school_from_params
      if !@school.save
        flash[:alert] = "An error occured! #{@school.errors.full_messages}"
        render 'new'
      else
        @teacher = @school.teachers.build(teacher_params)
        @teacher.validated = false
        @teacher.denied = false
        if @teacher.save
          flash[:success] =
            "Thanks for signing up for BJC, #{@teacher.first_name}! You'll hear from us shortly. Your email address is: #{@teacher.email}."
          TeacherMailer.form_submission(@teacher).deliver_now
          redirect_to root_path
        else
          redirect_to new_teacher_path, alert: "An error occurred while trying to submit teacher information. #{@teacher.errors.full_messages}"
        end
      end
    end
  end

  def edit
    @teacher = Teacher.find(params[:id])
    @school = @teacher.school
    @status = is_admin? ? "Admin" : "Teacher"
    @is_editing = true
  end

  def update
    @teacher = Teacher.find(params[:id])
    @school = @teacher.school
    @teacher.update(teacher_params)
    @school.update(school_params)
    @teacher.save!
    @school.save!
    if is_admin?
      flash[:success] = "Saved #{@teacher.full_name}"
      redirect_to teachers_path, notice: "Successfully updated information"
    else
      redirect_to edit_teacher_path(current_user.id), notice: "Successfully updated your information"
    end
  end

  def validate
    # TODO: Check if teacher is already denied (MAYBE)
    # TODO: Clean this up so the counter doesn't need to be manually incremented.
    teacher = Teacher.find(params[:id])
    teacher.validated = true
    teacher.denied = false
    teacher.school.num_validated_teachers += 1
    teacher.school.save!
    teacher.save!
    TeacherMailer.welcome_email(teacher).deliver_now
    redirect_to root_path
  end

  def deny
    # TODO: Require admin helper.
    # TODO: Check if teacher is already validated (MAYBE)
    # TODO: Clean this up so the counter doesn't need to be manually incremented.
    teacher = Teacher.find(params[:id])
    teacher.validated = false
    teacher.denied = true
    teacher.school.num_denied_teachers += 1
    teacher.school.save!
    teacher.save!
    # Replace with deny email later
    # TeacherMailer.welcome_email(teacher).deliver_now
    redirect_to root_path
  end

  def delete
    if !is_admin?
      redirect_to root_path, alert: "Only administrators can delete!"
    else
      Teacher.delete(params[:id])
      redirect_to root_path
    end
  end

  private

  def school_from_params
    School.find_by(name: school_params[:name], city: school_params[:city], state: school_params[:state]) || School.new(school_params)
  end

  def set_teacher_and_school
    @teacher = Teacher.new(teacher_params)
    @school = School.new(school_params)
  end

  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name, :school, :email, :status, :snap,
      :more_info, :personal_website, :education_level)
  end

  def school_params
    params.require(:school).permit(:name, :city, :state, :website)
  end

  def sanitize_params
    if params[:teacher]
      if params[:teacher][:status]
        params[:teacher][:status] = params[:teacher][:status].to_i
      end
      if params[:teacher][:education_level]
        params[:teacher][:education_level] = params[:teacher][:education_level].to_i
      end
    end
  end
end
