$(function() {
  $(".answer_controls [data-action='create_answer']").click(function(e) {
    e.preventDefault();
    $(this).hide();
    $(".answer_controls .answer_form_wrapper").show();
  });
});