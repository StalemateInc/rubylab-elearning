class ValidateEmailsFromInput
  include Interactor
  EMAIL_REGEXP = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
 
  # Validate emails and add to array context.emails
  
  def call
    begin
      context.regexp = EMAIL_REGEXP
      context.emails = []
      arr = []
      if context.email
        context.email.each do |e|
          e.downcase!
          if e =~ /, /
            arr.push(e.split(', '))
          elsif e =~ / /
            arr.push(e.split)
          else
            arr.push(e)
          end
        end
        arr.flatten.uniq.each do |parse_email|
          context.emails.push(parse_email) if parse_email =~ EMAIL_REGEXP
        end
      end
    rescue => e
      context.fail!(message: e)
    end
  end
end
