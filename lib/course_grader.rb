class CourseGrader
  def initialize(zipped, checked_textboxes)
    @zipped = zipped
    @checked_textboxes = checked_textboxes
  end

  def calculate_grade
    values = grade.values
    (values.count(true) / values.length.to_f * 100).ceil
  end

  private

  def grade
    resulting_hash = Hash.new(false)
    @zipped.each do |question, answer|
      user_answers = answer.last.answer
      correct_answers = question.answer_list.correct_answers
      if user_answers == correct_answers
        resulting_hash[question.id] = true
      else
        resulting_hash[question.id] = false
      end
    end
    @checked_textboxes.each_pair do |key, _value|
      resulting_hash[key.to_i] = true
    end if @checked_textboxes

    resulting_hash
  end

end