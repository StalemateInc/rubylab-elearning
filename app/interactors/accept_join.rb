# frozen_string_literal: true

class AcceptJoin < BaseInteractor

  # context:
  # request: JoinRequest, organization: Organization, user: User

  def call
    if context.request.update(status: :accepted)
      context.message = "User has been successfully added to an organization \"#{context.organization.name}\""
    else
      fail_with_message('An error occurred while confirming the join request')
      content.errors.merge!(context.request.errors)
    end
  end
end