class CheckController < ApplicationController

  before_action :set_course
  before_action :set_user, except: %i[index finish]

  # GET /courses/:id/check/
  def index
    @awaiting_participations = @course.participations.where(await_check: true)
  end

  # GET /courses/:id/check/:user_id/
  def show
    questions = @course.questions.includes(:answer_list)
    user_answers = questions.map { |q| q.user_answers.where(user: @user) }
    @zipped = questions.zip(user_answers)
  end

  # POST /courses/:id/check/:user_id/grade
  def grade
    FinalizeCourseCompletion.call(user: @user,
                                  course: @course,
                                  checked_text_questions: checked_params)
    redirect_to check_course_path(@course)
  end

  # POST /courses/:id/finish
  def finish
    participation = Participation.find_by(user: current_user, course: @course)
    if !participation.await_check && @course.questions.where(question_type: :textbox).empty?
      FinalizeCourseCompletion.call(user: current_user,
                                    course: @course,
                                    checked_text_questions: {})
    else
      flash[:success] = 'Congratulations on finishing this course! Your results will be known shortly, stay tuned.'
      participation.update(await_check: true)

    end
    redirect_to course_path(@course)
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def checked_params
    params.permit(checked: [])
  end
end