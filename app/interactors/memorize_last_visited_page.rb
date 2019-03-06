class MemorizeLastVisitedPage < BaseInteractor

  # context:
  # user: User, course: Course, page: Page

  def call
    participation = Participation.find_by(user: context.user, course: context.course)
    last_page = participation.page
    remaining_pages = context.page.full_sequence
    participation.update(page: context.page) unless context.page.before?(last_page, remaining_pages)
    context.remaining_pages = remaining_pages
  end
end