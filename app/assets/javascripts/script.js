$(function() {
    $('#edit_question').click(function(e) {
        e.preventDefault();
        $('.edit_question').show();
        $('#edit_question').hide();
    });

    $('#cancel_edit_question').click(function(e) {
        e.preventDefault();
        $('.edit_question').hide();
        $('#edit_question').show();
    });

    $('#answers').on('click', '.edit_answer_btn', function(e) {
        e.preventDefault();
        var clickId = this.id;
        $('form#edit_answer_' + clickId).show();
        $(this).hide();
    });

    $('#answers').on('click', '.cancel_edit_answer', function(e) {
        e.preventDefault();
        $('.edit_answer').hide();
        $(this).parent('form').parent('.answer').children('.edit_answer_btn').show();
    });

    $('#question').bind('ajax:success', function(e, data, status, xhr) {
        var response;
        response = $.parseJSON(xhr.responseText);
        return $('#question .votes_block').html(response.message);
    });

    $('#answers').bind('ajax:success', function(e, data, status, xhr) {
        var response;
        response = $.parseJSON(xhr.responseText);
        return $('#answer-' + response.voted_id + ' .votes_block').html(response.message);
    });

    userID = $('#answers').data("user");
    questionID = $('#answers').data("question");

    PrivatePub.subscribe("/questions/" + questionID + "/answers", function(data, channel) {
        answer = $.parseJSON(data.answer);
        if(answer.user_id != userID) {
            $('#answers').append('<div class="answer" id="answer-' + answer.id + '"><p class="answer_body">' + answer.body + '</p><div class="votes_block">Оценка 0</div><div id="answers_comments">Comments<ul><div id="no_comment">No comments</div></ul></div></div>');
        }
    });

    PrivatePub.subscribe("/questions/" + questionID + "/comments", function(data, channel) {
        comment = $.parseJSON(data.comment);
        $('#question #question_comments #no_comment').hide();
        $('#question #question_comments #new_comment #comment_body').val('');
        $('#question #question_comments ul').append('<li class="comment">' + comment.body + '</li>');
    });

    PrivatePub.subscribe("/questions/" + questionID + "/answers/comments", function(data, channel) {
        comment = $.parseJSON(data.comment);
        $('#answers #answer-' + comment.commentable_id + ' #answers_comments #new_comment #comment_body').val('');
        $('#answers #answer-' + comment.commentable_id + ' #answers_comments #no_comment').hide();
        $('#answers #answer-' + comment.commentable_id + ' #answers_comments ul').append('<li class="comment">' + comment.body + '</li>');
    });

    PrivatePub.subscribe("/questions", function(data, channel) {
        question = $.parseJSON(data.question);
        $("#questions").append('<div class="question"><h2><a href="/questions/' + question.id + '">' + question.title + '</a></h2><p>' + question.body + '</p></div>');
    });
});