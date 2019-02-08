# frozen_string_literal: true

class AcceptJoinRequest
  include Interactor::Organizer

  # context:
  # user: User, organization: Organization, request: JoinRequest
  organize AddUserToOrganization, AcceptJoin
end