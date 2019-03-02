var getSiblings = function (elem) {
    var siblings = [];
    var sibling = elem;
    while (sibling) {
        if (sibling.nodeType === 1 && sibling !== elem) {
            siblings.push(sibling);
        }
        sibling = sibling.nextSibling
    }
    return siblings;
};

document.addEventListener('turbolinks:load', function() {
    var questionForms = document.querySelectorAll('.render_form');
    questionForms.forEach(function (questionForm) {
        questionForm.addEventListener('ajax:success', function(event) {
            [data, status, xhr] = event.detail;
            var newQuestionBlock = data.body.firstChild;
            var destroyFormLink = newQuestionBlock.querySelector('.destroy_link');
            var questionCounterElement = document.getElementById('question-counter');
            var counter = parseInt(questionCounterElement.value);
            newQuestionBlock.setAttribute('data-index', counter);
            questionCounterElement.value = counter + 1;
            destroyFormLink.addEventListener('click', function () {
                var questionCounterElement = document.getElementById('question-counter');
                var counter = parseInt(questionCounterElement.value);
                questionCounterElement.value = counter - 1;
                updateIndicesBelow(destroyFormLink.parentNode);
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
        destroyLink.addEventListener('click', function() {
            var statusInput = destroyLink.parentNode.querySelector('input[name="questions[][status]"]');
            var status = statusInput.value.split('-')[0];
            var questionId = statusInput.value.split('-')[1];
            if(status == 'created') {
                statusInput.setAttribute('value', 'deleted-' + questionId);
                destroyLink.innerHTML = 'return';
            }
            else {
                statusInput.setAttribute('value', 'created-' + questionId);
                destroyLink.innerHTML = 'delete';
            }
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
    rightAnswer.setAttribute('name', 'correct_answers[' + answersContainer.parentNode.getAttribute('data-index') + '][]');
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

function updateIndicesBelow(node) {
    getSiblings(node).forEach(function (sibling) {
        var prev_val = parseInt(sibling.getAttribute('data-index')) - 1;
        sibling.setAttribute('data-index', prev_val);
    });
}
