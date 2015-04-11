$(function() {
  //var answer_form_template = _.template( $("#answer_form_template").html() );
  //var answer_template = _.template( $("#answer_template").html() );
  //var answers_template = _.template( $("#answers_template").html() );
  //var error_messages_template = _.template( $("#error_messages_template").html() );

  //function showAnswerForm(e) {
  //  e.preventDefault();
  //  var target = $(e.target);
  //  target.hide();
  //  var answerElem = target.closest(".answer");
  //  var answer = answerElem.data('answer');
  //  answerElem.find(".answer_form_wrapper").html(answer_form_template( { answer: answer } ));
  //}

  //function hideAnswerForm(e) {
  //  e.preventDefault();
  //  var parentElem = $(e.target).closest('.answer');
  //  parentElem.find('[data-action="answer"]').show();
  //  parentElem.find('[data-action="edit_answer"]').show();
  //  parentElem.find(".answer_form_wrapper").empty();
  //}
  
  //$("body").on("click", '#answer_new [data-action="new_answer"]', showAnswerForm);
  //$("body").on("click", '.answers .answer [data-action="edit_answer"]', showAnswerForm);
  //$("body").on("click", '.answer [data-action="cancel_edit_answer"]', hideAnswerForm);

  
  
  
  //addAjaxListener(".new_answer_wrapper", "form.new_answer", function(answers) {
  //  showAnswers(answers);
  //  showAnswer();
  //});

  //addAjaxListener(".answers_wrapper", "form.new_answer", showAnswer);

  //addAjaxListener(".answers_wrapper", 'a[data-action="delete_answer"]', removeAnswer);
 
  //addAjaxListener( ".answers_wrapper", ".answer_best_false a, .answer_best_true a", showAnswers);


  
  //function onMaybeError(e, xhr, status, successHandler) {
  //  if (e.target !== e.currentTarget) return;
  //  var obj = $.parseJSON(xhr.responseText);
  //  if (status === 'parsererror') {
  //    successHandler && successHandler(obj);
  //    return;
  //  }
  //  var errorMessages = obj;
  //  var answerElem = $(e.target).closest(".answer");
  //  showErrors(errorMessages, answerElem.find(".error_messages_wrapper"));
  //}

  //function onSuccess(e, xhr, successHandler) {
  //  if (e.target !== e.currentTarget) return;
  //  var obj = $.parseJSON(xhr.responseText);
  //  successHandler(obj);
  //}

  //function addAjaxListener(elem, target, handler) {
  //  $(elem).on("ajax:success", target, function(e, data, status, xhr) {
  //    onSuccess(e, xhr, handler);
  //  });
  //  $(elem).on("ajax:error", target, function(e, xhr, status, error) {
  //    onMaybeError(e, xhr, status, handler);
  //  });
  //}
  //
  //function showErrors(errorMessages, wrapper) {
  //  wrapper.html( error_messages_template( { error_messages: errorMessages } ) );
  //}

  //function showAnswer(answer) {
  //  if (!answer) {
  //    answer = $("#answer_new").data('answer');
  //  }
  //  var answerHtml = answer_template({ answer: answer });
  //  var answerId = "#answer_" + (answer.id || "new");
  //  $(answerId).replaceWith(answerHtml);
  //  $(answerId).data('answer', answer);
  //}

  //function showAnswers(answers) {
  // $(".answers_wrapper").html(answers_template( { answers: answers, answer_template: answer_template } ));
  // _.forEach(answers, function(answer) {
  //   $("#answer_" + answer.id).data('answer', answer);
  // });
  //}

  //function removeAnswer(answer) {
  //  var answerId = "#answer_" + answer.id;
  //  $(answerId).closest('li').remove();
  //}
  
  //function initNewAnswer() {
  //  var new_answer_path = $(".new_answer_wrapper").data("new_question_answer_path");
  //  $.getJSON(
  //    new_answer_path
  //  ).done(function(answer) {
  //    $(".new_answer_wrapper").html('<div id="answer_new"/>');
  //    showAnswer(answer);
  //  });
  //}

  //function initAnswers() {
  //  var question_answers_path = $(".answers_wrapper").data("question_answers_path");
  //  $.getJSON(
  //    question_answers_path
  //  ).done(function(answers) {
  //    showAnswers(answers);
  //  });
  //}

  //function init() {
  //  initNewAnswer();
  //  initAnswers();
  //}

  //init();
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  function AnswerList(newAnswerWrapper, answersWrapper) {

    this._answer_form_template = _.template( $("#answer_form_template").html() );
    this._answer_template = _.template( $("#answer_template").html() );
    this._answers_template = _.template( $("#answers_template").html() );
    this._error_messages_template = _.template( $("#error_messages_template").html() );


    this._newAnswerWrapper = $(newAnswerWrapper);
    this._answersWrapper = $(answersWrapper);
    this._initNewAnswer();
    this._initAnswers();

    this._addAjaxListener(".new_answer_wrapper", "form.new_answer", function(answers) {
      this.showAnswers(answers);
      this.showAnswer();
    }.bind(this));
    this._addAjaxListener(".answers_wrapper", "form.new_answer", this.showAnswer.bind(this));
    this._addAjaxListener(".answers_wrapper", 'a[data-action="delete_answer"]', this.removeAnswer.bind(this));
    this._addAjaxListener( ".answers_wrapper", ".answer_best_false a, .answer_best_true a", this.showAnswers.bind(this));


    this._newAnswerWrapper.on("click", '#answer_new [data-action="new_answer"]', this._showAnswerForm.bind(this));
    this._answersWrapper.on("click", '.answers .answer [data-action="edit_answer"]', this._showAnswerForm.bind(this));
    this._answersWrapper.on("click", '.answer [data-action="cancel_edit_answer"]', this._hideAnswerForm.bind(this));

  }

  AnswerList.prototype.showAnswer = function(answer) {
    if (!answer) {
      answer = $("#answer_new").data('answer');
    }
    var answerHtml = this._answer_template({ answer: answer });
    var answerId = "#answer_" + (answer.id || "new");
    $(answerId).replaceWith(answerHtml);
    $(answerId).data('answer', answer);
  };

  AnswerList.prototype.showAnswers = function(answers) {
    this._answersWrapper.html(this._answers_template( { answers: answers, answer_template: this._answer_template } ));
    _.forEach(answers, function(answer) {
      $("#answer_" + answer.id).data('answer', answer);
    });
  };

  AnswerList.prototype.removeAnswer = function(answer) {
    var answerId = "#answer_" + answer.id;
    $(answerId).closest('li').remove();
  };


  AnswerList.prototype._showAnswerForm = function(e) {
    e.preventDefault();
    var target = $(e.target);
    target.hide();
    var answerElem = target.closest(".answer");
    var answer = answerElem.data('answer');
    answerElem.find(".answer_form_wrapper").html(this._answer_form_template( { answer: answer } ));
  };

  AnswerList.prototype._hideAnswerForm = function(e) {
    e.preventDefault();
    var parentElem = $(e.target).closest('.answer');
    parentElem.find('[data-action="answer"]').show();
    parentElem.find('[data-action="edit_answer"]').show();
    parentElem.find(".answer_form_wrapper").empty();
  };

  AnswerList.prototype._initNewAnswer = function() {
    var new_answer_path = this._newAnswerWrapper.data("new_question_answer_path");
    $.getJSON(
      new_answer_path
    ).done(function(answer) {
      this._newAnswerWrapper.html('<div id="answer_new"/>');
      this.showAnswer(answer);
    }.bind(this));
  };

  AnswerList.prototype._initAnswers = function() {
    var question_answers_path = this._answersWrapper.data("question_answers_path");
    $.getJSON(
      question_answers_path
    ).done(function(answers) {
      this.showAnswers(answers);
    }.bind(this));
  };

  AnswerList.prototype._onMaybeError = function(e, xhr, status, successHandler) {
    if (e.target !== e.currentTarget) return;
    var obj = $.parseJSON(xhr.responseText);
    if (status === 'parsererror') {
      successHandler && successHandler(obj);
      return;
    }
    var errorMessages = obj;
    var answerElem = $(e.target).closest(".answer");
    this._showErrors(errorMessages, answerElem.find(".error_messages_wrapper"));
  };

  AnswerList.prototype._onSuccess = function(e, xhr, successHandler) {
    if (e.target !== e.currentTarget) return;
    var obj = $.parseJSON(xhr.responseText);
    successHandler(obj);
  };

  AnswerList.prototype._addAjaxListener = function(elem, target, handler) {
    $(elem).on("ajax:success", target, function(e, data, status, xhr) {
      this._onSuccess(e, xhr, handler);
    }.bind(this));
    $(elem).on("ajax:error", target, function(e, xhr, status, error) {
      this._onMaybeError(e, xhr, status, handler);
    }.bind(this));
  };

  AnswerList.prototype._showErrors = function(errorMessages, wrapper) {
    wrapper.html( this._error_messages_template( { error_messages: errorMessages } ) );
  };


  var answersList = new AnswerList(".new_answer_wrapper", ".answers_wrapper");

});
