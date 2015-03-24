$(function() {
  function showAnswerForm(e) {
    var target = $(e.target);
    var action = target.data('action');
    if (action !== 'create_answer' && action !== 'edit_answer') {
      return;
    }
    e.preventDefault();
    target.hide();
    var parent = target.parent(".answer");
    parent.find("h2").show();
    parent.find("form").show();
  }
  $(".answer [data-action='create_answer']").click(showAnswerForm);
  $(".answers").click(showAnswerForm);
});
