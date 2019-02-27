module PagesHelper
  def render_question(question, answers, user_answer = nil)
    out = '<div class="test-question">'
    out << "#{link_to 'destroy', destroy_question_path(question), remote: true, method: :delete, class: 'destroy_link'}"
    out << "<h4>#{question.content}</h4>"
    out << '<div class="test-answers">'
    
    q_id = question.id
    case question.question_type
    when "textbox"
      out << text_field_tag("user_answers[#{q_id}]",
                            user_answer ? user_answer.answer : '',
                            id: "q-#{q_id}-a-#{answers.id}",
                            disabled: user_answer ? true : false)
    when "radio"
      u_answers = set_boxes_answers(user_answer)
      is_disabled = !((answers.answers.keys & u_answers).empty?)
      answers.answers.each do |key, value|
        out << '<div class="test-answer-radio">'
        out << tag.span(value)
        out << radio_button_tag("user_answers[#{q_id}][]",
                                key,
                                key.in?(u_answers),
                                id: "q-#{q_id}-a-#{answers.id}",
                                disabled: is_disabled)
        out << '</div>'
      end
    when "checkbox"
      u_answers = set_boxes_answers(user_answer)
      is_disabled = !((answers.answers.keys & u_answers).empty?)
      answers.answers.each do |key, value|
        out << '<div class="test-answer-checkbox">'
        out << tag.span(value)
        out << check_box_tag("user_answers[#{q_id}][]",
                             key,
                             key.in?(u_answers),
                             disabled: is_disabled)
        out << '</div>'
      end
    end
    out << '</div></div>'

    out
  end

  private

  def set_boxes_answers(user_answer)
    if user_answer
      user_answer.answer.split(' ')
    else
      []
    end
  end
end
