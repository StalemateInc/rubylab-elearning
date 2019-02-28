class PagesController < ApplicationController
  include Pundit
  before_action :authenticate_user!
  before_action :set_course
  before_action :set_page, except: %i[index new create]
  after_action :clear_flash, only: :destroy

  # GET /courses/:course_id/pages
  def index
    authorize Page.new(course: @course)
    @pages = Page.all_for(@course)
  end

  # GET /courses/:id/pages/new
  def new
    @page = Page.new(course: @course)
    authorize @page
  end

  # POST /courses/:id/pages
  def create
    authorize Page.new(course: @course)

    result = ConfigurePageBeforeInsertion.call(course: @course, index: params[:page_index].to_i)
    @page = Page.new(page_params.merge(course: @course, previous_page: result.previous_page, next_page: result.next_page))

    if @page.save
      create_questions(@page) if params[:answer_list]
      flash[:success] = 'Page was successfully created'
      redirect_to pages_course_path(@course)
    else
      flash[:notice] = 'An error occurred while creating the page'
      redirect_back(fallback_location: root_path)
    end
  end

  # GET /courses/:id/pages/:page_id/edit
  def edit
    authorize @page
    build_test
  end

  # PATCH /courses/:id/pages/:page_id
  def update
    authorize @page
    if @page.update(page_params)
      create_questions(@page)
      flash[:success] = 'Page update successful.'
    else
      flash[:notice] = 'Failed to update a page.'
    end
    redirect_to pages_course_path(@course)
  end

  # DELETE /courses/:id/pages/:page_id
  def destroy
    authorize @page
    if @page.destroy
      flash[:success] = 'Successfully deleted a page.'
    else
      flash[:notice] = 'Failed to delete a page.'
    end
    redirect_to pages_course_path(@course)
  end

  # GET /courses/:id/pages/:page_id
  def show
    authorize @page
    build_test
    result = MemorizeLastVisitedPage.call(user: current_user, course: @course, page: @page)
    if result.remaining_pages.empty?
      participation = Participation.find_by(user: current_user, course: @course)
      if !participation.await_check && @course.questions.where(question_type: :textbox).empty?
        # initiate test process
      else
        participation.await_check!
      end
    end
  end

  private

  def build_test
    @questions = @page.questions
    @answers = AnswerList.where(question: @questions)
    @user_answers = UserAnswer.where(question: @questions)
  end

  def set_page
    @page = Page.find(params[:page_id])
  end

  def set_course
    @course = Course.find(params[:id])
  end

  def create_questions(page)
    if params[:answer_list]
      params[:answer_list].each do |answer_list_params|
        question_params = params[:questions].shift
        if question_params[:status]
          status, question_id = question_params[:status].split('-')
          if status == 'created'
            update_question(question_id, question_params, answer_list_params)
          else
            destroy_question(question_id)
          end
        else
          answer_list = AnswerList.new
          answer_list.answers = answer_list_params[:answers]
          answer_list.correct_answers = answer_list_params[:correct_answers].join(' ')
          answer_list.question = Question.create(content: question_params[:content],
                                                 question_type: question_params[:question_type],
                                                 page: page)
          answer_list.save
        end
      end
    end
  end

  def update_question(question_id, question_params, answer_list_params)
    question = Question.find(question_id)
    question.update(content: question_params[:content])
    question.answer_list.update(answers: answer_list_params[:answers],
                                correct_answers: answer_list_params[:correct_answers].join(' '))
  end

  def destroy_question(question_id)
    question = Question.find(question_id)
    question.destroy
  end

  def page_params
    params.require(:page).permit(:html, :name, answers: [])
  end

end
