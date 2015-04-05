$(function() {
  function showAnswerForm(e) {
    e.preventDefault();
    var target = $(e.target);
    var form = target.data("form");
    target.hide();
    var parent = target.parent(".answer");
    parent.find(".answer_form_wrapper").html(form);
  }
  
  $("body").on("click", '#answer_new [data-action="new_answer"]', showAnswerForm);
  $("body").on("click", '.answers .answer [data-action="edit_answer"]', showAnswerForm);
});
