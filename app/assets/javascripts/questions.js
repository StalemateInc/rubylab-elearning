document.addEventListener('DOMContentLoaded', function() {
    var answerIndex = 0;
    var answerButtons = document.querySelectorAll('.add-answer');
    answerButtons.forEach(function (answerButton) {
        answerButton.addEventListener('click', function () {
            addAnswer(answerButton.getAttribute('type'), answerIndex, answerButton.parentNode.querySelector('.answers'));
            answerIndex++;
        });
    });
});

function addAnswer(type, answerIndex, answersContainer) {
    var newAnswerBlock = document.createElement('div');
    newAnswerBlock.classList.add('answer');
    var newAnswer = document.createElement('input');
    var rightAnswer = document.createElement('input');
    newAnswer.setAttribute('name', 'answer_list[answers][' + answerIndex + ']');
    rightAnswer.setAttribute('name', 'answer_list[correct_answers]');
    rightAnswer.setAttribute('type', type);
    rightAnswer.setAttribute('value', answerIndex);
    newAnswer.setAttribute('type', 'text');
    newAnswer.setAttribute('value', 'text of the answer');
    newAnswerBlock.appendChild(newAnswer);
    newAnswerBlock.appendChild(rightAnswer);
    answersContainer.appendChild(newAnswerBlock);
}
