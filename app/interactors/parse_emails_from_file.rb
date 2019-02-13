class ParseEmailsFromFile
  include Interactor

  # Validate email from csv file and add it to context.emails

  def call
    begin
      if context.file
        emails = ''
        emails = context.file.read do |line|
           line
        end
        emails = emails.split("\n")
        emails.each do |email|
          email.downcase!
          if email =~ context.regexp
            context.emails.push(email)
          end
        end
      end
    rescue => e
      context.fail!(message: e)
    end
  end
end
