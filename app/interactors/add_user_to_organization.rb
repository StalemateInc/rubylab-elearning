# frozen_string_literal: true

class AddUserToOrganization < BaseInteractor

  # context:
  # user: User, organization: Organization

  def call
    binding.pry
    membership = Membership.new(user: context.user, organization: context.organization)
    if membership.valid?
      membership.save!
      context.membership = membership
    else
      fail_with_message('An error occurred while adding the user to organization')
      content.errors.merge!(membership.errors)
    end
  end

  def rollback
    context.membership.destroy!
  end

end