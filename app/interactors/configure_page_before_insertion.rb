class ConfigurePageBeforeInsertion < BaseInteractor

  # context:
  # course: Course, index: Integer

  def call
    sequence = Page.all_for(context.course)
    index = context.index - 1
    index = index.in?(0..sequence.length) ? index : sequence.length
    context.previous_page = (index - 1).negative? ? nil : sequence[index - 1]
    context.next_page = sequence[index]
  end
end