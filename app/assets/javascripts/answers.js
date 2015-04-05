$(function() {
  function showAnswerForm(e) {
    e.preventDefault();
    var target = $(e.target);
    var form = target.data("form");
    target.hide();
    var parent = target.parent(".answer");
    parent.find(".answer_form_wrapper").html(form);
  }

  function hideAnswerForm(e) {
    e.preventDefault();
    var parentElem = $(e.target).parentsUntil('body', '.answer');
    parentElem.find('[data-action="new_answer"]').show();
    parentElem.find('[data-action="edit_answer"]').show();
    parentElem.find(".answer_form_wrapper").empty();
  }
  
  $("body").on("click", '#answer_new [data-action="new_answer"]', showAnswerForm);
  $("body").on("click", '.answers .answer [data-action="edit_answer"]', showAnswerForm);
  $("body").on("click", '.answer [data-action="cancel_edit_answer"]', hideAnswerForm);
});
