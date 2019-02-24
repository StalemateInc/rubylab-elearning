document.addEventListener('DOMContentLoaded', function() {
    var questionForm = document.getElementById('render_form');
    questionForm.addEventListener('ajax:success', function(event) {
        [data, status, xhr] = event.detail;
        var newQuestionForm = data.body.firstChild;
        document.querySelector('.questions').appendChild(newQuestionForm);
        var answerButton = newQuestionForm.querySelector('.add-answer');
        answerButton.addEventListener('click', function () {
            addAnswer(answerButton.getAttribute('type'),
                newQuestionForm.elements['index'].value,
                answerButton.parentNode.querySelector('.answers'));
            newQuestionForm.elements['index'].setAttribute('value',
                parseInt(newQuestionForm.elements['index'].value) + 1);
        });
    });

});

function addAnswer(type, answerIndex, answersContainer) {
    var newAnswerBlock = document.createElement('div');
    newAnswerBlock.classList.add('answer');
    var newAnswer = document.createElement('input');
    var rightAnswer = document.createElement('input');
    newAnswer.setAttribute('name', 'answer_list[answers][' + answerIndex + ']');
    rightAnswer.setAttribute('name', 'answer_list[correct_answers][]');
    rightAnswer.setAttribute('type', type);
    rightAnswer.setAttribute('value', answerIndex);
    newAnswer.setAttribute('type', 'text');
    newAnswer.setAttribute('value', 'text of the answer');
    newAnswerBlock.appendChild(newAnswer);
    newAnswerBlock.appendChild(rightAnswer);
    answersContainer.appendChild(newAnswerBlock);
}
