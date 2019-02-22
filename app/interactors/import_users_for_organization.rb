# frozen_string_literal: true

class ImportUsersForOrganization
  include Interactor::Organizer

  organize ValidateEmailsFromInput, ParseEmailsFromFile, SendInvintation
end