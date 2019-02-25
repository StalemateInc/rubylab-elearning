require 'csv'

class UserImportCSVParser

  attr_reader :output

  def initialize(output)
    @output = output
  end

  def parse(file)
    CSV::foreach(file) do |row|
      @output << row[0]
    end
  end
end