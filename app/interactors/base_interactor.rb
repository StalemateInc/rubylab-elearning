# frozen_string_literal: true

class BaseInteractor
  include Interactor

  def fail_with_message(message)
    context.fail!(message: message)
  end
end