document.addEventListener('turbolinks:load', function() {
    var questionForms = document.querySelectorAll('.render_form');
    questionForms.forEach(function (questionForm) {
        questionForm.addEventListener('ajax:success', function(event) {
            [data, status, xhr] = event.detail;
            var newQuestionBlock = data.body.firstChild;
            document.querySelector('.questions').appendChild(newQuestionBlock);
            var answerButton = newQuestionBlock.querySelector('.add-answer');
            answerButton.addEventListener('click', function () {
                addAnswer(answerButton.getAttribute('type'),
                    newQuestionBlock.querySelector('#index').value,
                    answerButton.parentNode.querySelector('.answers'));
                newQuestionBlock.querySelector('#index').setAttribute('value',
                    parseInt(newQuestionBlock.querySelector('#index').value) + 1);
            });
        });
    });
});

function addAnswer(type, answerIndex, answersContainer) {
    var newAnswerBlock = document.createElement('div');
    newAnswerBlock.classList.add('answer');
    var newAnswer = document.createElement('input');
    var rightAnswer = document.createElement('input');
    newAnswer.setAttribute('name', 'answer_list[][answers][' + answerIndex + ']');
    rightAnswer.setAttribute('name', 'answer_list[][correct_answers][]');
    rightAnswer.setAttribute('type', type);
    rightAnswer.setAttribute('value', answerIndex);
    newAnswer.setAttribute('type', 'text');
    newAnswer.setAttribute('value', 'text of the answer');
    newAnswerBlock.appendChild(newAnswer);
    newAnswerBlock.appendChild(rightAnswer);
    answersContainer.appendChild(newAnswerBlock);
}
