
document.addEventListener('DOMContentLoaded', function() {
    var answerIndex = 0;
    document.getElementById('add-answer')
                    .addEventListener('click', function () {
                        var newAnswerBlock = document.createElement('div');
                        newAnswerBlock.classList.add('answer');
                        var newAnswer = document.createElement('input');
                        var rightAnswer = document.createElement('input');
                        newAnswer.setAttribute('name', 'answer[' + answerIndex + ']');
                        rightAnswer.setAttribute('name', 'right-answer[]');
                        rightAnswer.setAttribute('type', 'radio');
                        rightAnswer.setAttribute('value', answerIndex);
                        newAnswer.setAttribute('type', 'text');
                        newAnswer.setAttribute('value', 'text of the answer');
                        var answersContainer = document.querySelector('.answers');
                        newAnswerBlock.appendChild(newAnswer);
                        newAnswerBlock.appendChild(rightAnswer);
                        answersContainer.appendChild(newAnswerBlock);
                        answerIndex++;
        });
});

function addAnswer(type) {
    switch (type) {
        case 1: break;
        case 2: break;
    }
}
