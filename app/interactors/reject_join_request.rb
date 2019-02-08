# frozen_string_literal: true

class RejectJoinRequest < BaseInteractor

  # context:
  # request: JoinRequest, organization: Organization, comment: text

  def call
    if context.request.update(status: :declined, comment: context.comment)
      context.message = "User has been declined on membership in \"#{context.organization.name}\""
    else
      fail_with_message('An error occurred while rejecting join request')
      content.errors.merge!(context.request.errors)
    end
  end

end