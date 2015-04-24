$(function() {
  $(".comments_wrapper").data('new_comment_form',
    $('.comments_wrapper form.new_comment').clone());

  $(".comments_wrapper").on("click", '[data-action="new_comment"]', function(e) {
    e.preventDefault();
    $(e.target).hide();
    $(".comments_wrapper form.new_comment").show();
  });
});
