$(function() {
  $("body").on("click", '.comments_wrapper [data-action="new_comment"]', function(e) {
    if (e.target !== e.currentTarget) return;
    e.preventDefault();
    var target = $(e.target);
    target.hide();
    var wrapper = target.closest('.comments_wrapper');
    var form = wrapper.find("form.new_comment");
    wrapper.data('new_comment_form', form.clone());
    form.show();
  });
});
