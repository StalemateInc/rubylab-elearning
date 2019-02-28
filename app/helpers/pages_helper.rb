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

  def render_question_form(question, answers, user_answers = nil)
    out = '<div class="test-question">'
    out << "#{link_to 'destroy', destroy_question_path(question), remote: true, method: :delete, class: 'destroy_link'}"
    out << '<div class="test-answers">'
    q_id = question.id
    right_answers = answers.correct_answers.split
    case question.question_type
    when "textbox"
      out << '<input name="questions[][content]" value="' + question.content + '">
              <div class="answers">
                <input type="text" name="answer_list[][answers][0]" value="this is a textbox question" style="display: none">
                <input type="text" name="answer_list[][correct_answers][]" value="' + answers.correct_answers + '">
              </div>
              <input name="questions[][question_type]" style="display: none" value="textbox">
              <input name="questions[][status]" style="display: none" value="created-' + q_id.to_s + '">'
    when "radio"
      out << '<input name="questions[][content]" value="' + question.content + '">
              <div class="answers">'
      answers.answers.each do |key, value|
        out << '<div class="answer">
                <input type="text" name=answer_list[][answers][' + key + '] value="' + value + '">'
        if key.to_s.in? right_answers
          out << '<input type="radio" name=answer_list[][correct_answers][] checked="true" value="' + key + '">'
        else
          out << '<input type="radio" name=answer_list[][correct_answers][] value="' + key + '">'
        end
        out << '</div>'
      end
      out << '</div>
              <p class="btn btn-outline-danger add-answer" type="checkbox" id="add-answer">Add answer</p>
              <input name="questions[][question_type]" style="display: none" value="checkbox">
              <input id="index" style="display: none" value="0">
              <input name="questions[][status]" style="display: none" value="created-' + q_id.to_s + '">'
    when "checkbox"
      out << '<input name="questions[][content]" value="' + question.content + '">
              <div class="answers">'
      answers.answers.each do |key, value|
        out << '<div class="answer">
                <input type="text" name=answer_list[][answers][' + key + '] value="' + value + '">'
        if key.to_s.in? right_answers
          out << '<input type="checkbox" name=answer_list[][correct_answers][] checked="true" value="' + key + '">'
        else
          out << '<input type="checkbox" name=answer_list[][correct_answers][] value="' + key + '">'
        end
          out << '</div>'
      end
      out << '</div>
              <p class="btn btn-outline-danger add-answer" type="checkbox" id="add-answer">Add answer</p>
              <input name="questions[][question_type]" style="display: none" value="checkbox">
              <input id="index" style="display: none" value="0">
              <input name="questions[][status]" style="display: none" value="created-' + q_id.to_s + '">'
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
