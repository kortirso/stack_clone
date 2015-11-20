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

	$('.edit_answer_btn').click(function(e) {
		e.preventDefault();
		var clickId = this.id;
		$('form#edit_answer_' + clickId).show();
		$(this).hide();
	});

	$('.cancel_edit_answer').click(function(e) {
		e.preventDefault();
		$('.edit_answer').hide();
		$(this).parent('form').parent('.answer').children('.edit_answer_btn').show();
	});
});