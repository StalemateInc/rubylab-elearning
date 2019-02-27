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
      # go test user answers
      # if no user answers present or all the values can be tested
      #   create CompletionRecord with values
      # if not all the values can be tested
      #   set await_check to true
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
    params[:answer_list].each do |answer_list_params|
      question = params[:questions].shift
      answer_list = AnswerList.new
      answer_list.answers = answer_list_params[:answers]
      answer_list.correct_answers = answer_list_params[:correct_answers].join(' ')
      answer_list.question = Question.create(content: question[:content],
                                             question_type: question[:question_type],
                                             page: page)
      answer_list.save
    end
  end

  def page_params
    params.require(:page).permit(:html, :name, answers: [])
  end

end
