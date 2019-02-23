class ParseEmailsForImport < BaseInteractor

  # context:
  # params: ActionController::Parameters

  EMAIL_REGEXP = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def call
    begin
      binding.pry
      emails = context.params[:email]
      csv = context.params[:csv]
      UserImportCSVParser.new(emails).parse(csv.tempfile) if csv
      emails.select! { |email| email =~ EMAIL_REGEXP }
      context.emails = emails.uniq
    rescue => e
      fail_with_message('Failed to get user emails during the import process.')
      context.errors.push(e)
    end
  end
end
