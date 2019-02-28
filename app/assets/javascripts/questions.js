document.addEventListener('turbolinks:load', function() {
    var questionForms = document.querySelectorAll('.render_form');
    questionForms.forEach(function (questionForm) {
        questionForm.addEventListener('ajax:success', function(event) {
            [data, status, xhr] = event.detail;
            var newQuestionBlock = data.body.firstChild;
            var destroyFormLink = newQuestionBlock.querySelector('.destroy_link');
            destroyFormLink.addEventListener('click', function () {
                destroyFormLink.parentNode.remove();
            });
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
    var destroyLinks = document.querySelectorAll('.destroy_link');
    destroyLinks.forEach(function (destroyLink) {
        destroyLink.addEventListener('ajax:success', function(event) {
            destroyLink.parentNode.remove();
        });
    });

    var addLinks = document.querySelectorAll('.add-answer');
    addLinks.forEach(function (addLink) {
        addLink.addEventListener('click', function () {
            var newQuestionBlock = addLink.parentNode;
            addAnswer(addLink.getAttribute('type'),
                newQuestionBlock.querySelector('#index').value,
                newQuestionBlock.querySelector('.answers'));
                newQuestionBlock.querySelector('#index').setAttribute('value',
                parseInt(newQuestionBlock.querySelector('#index').value) + 1);
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
    if(answerIndex == 0) {
        rightAnswer.setAttribute('checked', 'true');
    }
    newAnswer.setAttribute('type', 'text');
    newAnswer.setAttribute('value', 'text of the answer');
    newAnswerBlock.appendChild(newAnswer);
    newAnswerBlock.appendChild(rightAnswer);
    answersContainer.appendChild(newAnswerBlock);
}
