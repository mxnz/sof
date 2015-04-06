$(function() {
  function showQuestionForm(e) {
    e.preventDefault();
    var target = $(e.target);
    target.hide();
    $(".question_controls .question_form_wrapper").html(target.data("form"));
  }

  function hideQuestionForm(e) {
    e.preventDefault();
    var parentElem = $(e.target).parentsUntil("body", ".question");
    parentElem.find('.question_controls [data-action="edit_question"]').show();
    parentElem.find(".question_controls .question_form_wrapper").empty();
  }

  $("body").on('click', '.question_controls [data-action="edit_question"]', showQuestionForm);
  $("body").on('click', '.question_controls [data-action="cancel_edit_question"]', hideQuestionForm);
});
