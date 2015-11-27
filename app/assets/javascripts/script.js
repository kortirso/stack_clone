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
});