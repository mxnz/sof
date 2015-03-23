$(function() {
  $(".question_controls [data-action='edit_question']").click(function(e) {
    e.preventDefault();
    $(this).hide();
    $(".question_controls .question_form_wrapper").show();
  });
});
