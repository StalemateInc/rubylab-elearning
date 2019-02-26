module PagesHelper
  def render_question(question, answers)
    out = '<div class="test-question">'
    out << "<h4>#{question.content}</h4>"
    out << '<div class="test-answers">'
    
    q_id = question.id
    
    case question.question_type
    when "textbox"
      out << text_field_tag("user_answers[#{q_id}]", "", id: "q-#{q_id}-a-#{answers.id}")
    when "radio"
      answers.answers.each do |key, value|
        out << '<div class="test-answer-radio">'
        out << tag.span(value)
        out << radio_button_tag("user_answers[#{q_id}[]]", key, id: "q-#{q_id}-a-#{answers.id}")
        out << '</div>'
      end
    when "checkbox"
      answers.answers.each do |key, value|
        out << '<div class="test-answer-checkbox">'
        out << tag.span(value)
        out << check_box_tag("user_answers[#{q_id}[]]", key)
        out << '</div>'
      end
    end
    out << '</div></div>'

    out
  end
end
