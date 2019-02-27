class ImportUsersToOrganization
  include Interactor::Organizer

  organize ParseEmailsForImport, SendInvitation
end