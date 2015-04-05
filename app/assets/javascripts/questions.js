$(function() {
  function showQuestionForm(e) {
    e.preventDefault();
    var target = $(this);
    target.hide();
    $(".question_controls .question_form_wrapper").html(target.data("form"));
  }

  $("body").on('click', '.question_controls [data-action="edit_question"]', showQuestionForm);
});
