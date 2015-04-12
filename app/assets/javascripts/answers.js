$(function() {

  function AnswerList(newAnswerWrapper, answersWrapper) {

    this._answer_form_template = _.template( $("#answer_form_template").html() );
    this._answer_template = _.template( $("#answer_template").html() );
    this._answers_template = _.template( $("#answers_template").html() );
    this._error_messages_template = _.template( $("#error_messages_template").html() );


    this._newAnswerWrapper = $(newAnswerWrapper);
    this._answersWrapper = $(answersWrapper);
    this._newAnswerWrapper.html('<div id="answer_new" />');

    this._newAnswerWrapper.on("click", '#answer_new [data-action="new_answer"]', function(e) {
      e.preventDefault();
      this.showAnswerForm();
    }.bind(this));

    this._answersWrapper.on( "click", '.answers .answer [data-action="edit_answer"]', function(e) {
      e.preventDefault();
      var answer = $(e.target).closest('.answer').data('answer');
      this.showAnswerForm(answer);
    }.bind(this));

    this._newAnswerWrapper.on('click', '.answer [data-action="cancel_edit_answer"]', function(e) {
      e.preventDefault();
      this.hideAnswerForm();
    }.bind(this));

    this._answersWrapper.on("click", '.answer [data-action="cancel_edit_answer"]', function(e) {
      e.preventDefault();
      var answer = $(e.target).closest('.answer').data('answer');
      this.hideAnswerForm(answer);
    }.bind(this));

  }

  AnswerList.prototype.newAnswerWrapper = function() {
    return this._newAnswerWrapper;
  };

  AnswerList.prototype.answersWrapper = function() {
    return this._answersWrapper;
  };

  AnswerList.prototype.newAnswerPath = function() {
    return this._newAnswerWrapper.data("new_question_answer_path");
  };

  AnswerList.prototype.answersPath = function() {
    return this._answersWrapper.data("question_answers_path");
  };

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

  
  AnswerList.prototype.showAnswerForm = function(answer) {
    var answerElem = this._findAnswerElem(answer);
    var answer = answer || answerElem.data('answer');
    answerElem.find(".answer_form_wrapper").html(this._answer_form_template( { answer: answer } ));
  };

  
  AnswerList.prototype.hideAnswerForm = function(answer) {
    var answerElem = this._findAnswerElem(answer);
    answerElem.find('[data-action="answer"]').show();
    answerElem.find('[data-action="edit_answer"]').show();
    answerElem.find('.answer_form_wrapper').empty();
  };

  AnswerList.prototype.showAnswerErrors = function(errorMessages,  target) {
    var answerElem = $(target).closest(".answer");
    answerElem.find(".error_messages_wrapper").html(this._error_messages_template( { error_messages: errorMessages } ));
  };

  AnswerList.prototype._findAnswerElem = function(answer) {
    if (answer && answer.id) {
      var wrapper = this._answersWrapper;
      var answerId = '#answer_' + answer.id;
    } else {
      var wrapper = this._newAnswerWrapper;
      var answerId = "#answer_new";
    }
    return wrapper.find(answerId);
  };

  
  //----------------------------------------------------------------

  function AnswerListener(answerList) {
    this._answerList = answerList; 
  }

  AnswerListener.prototype.init = function() {
    this._initNewAnswer();
    this._initAnswers();

    this._addAjaxListener(this._answerList.newAnswerWrapper(), "form.new_answer", function(answers) {
      this._answerList.showAnswers(answers);
      this._answerList.showAnswer();
    }.bind(this));
    this._addAjaxListener(this._answerList.answersWrapper(), "form.new_answer", function(answer) {
      this._answerList.showAnswer(answer);
    }.bind(this));
    this._addAjaxListener(this._answerList.answersWrapper(), 'a[data-action="delete_answer"]', function(answer) {
      this._answerList.removeAnswer(answer);
    }.bind(this));
    this._addAjaxListener(this._answerList.answersWrapper(), ".answer_best_false a, .answer_best_true a", function(answers) {
      this._answerList.showAnswers(answers);
    }.bind(this));
  };

   AnswerListener.prototype._initNewAnswer = function() {
    $.getJSON(
      this._answerList.newAnswerPath()
    ).done(function(answer) {
      this._answerList.showAnswer(answer);
    }.bind(this));
  };
 
  AnswerListener.prototype._initAnswers = function() {
    $.getJSON(
      this._answerList.answersPath()
    ).done(function(answers) {
      this._answerList.showAnswers(answers);
    }.bind(this));
  };

  AnswerListener.prototype._onMaybeError = function(e, xhr, status, successHandler) {
    if (e.target !== e.currentTarget) return;
    var obj = $.parseJSON(xhr.responseText);
    if (status === 'parsererror') {
      successHandler && successHandler(obj);
      return;
    }
    var errorMessages = obj;
    this._answerList.showAnswerErrors(errorMessages, e.target);
  };

  AnswerListener.prototype._onSuccess = function(e, xhr, successHandler) {
    if (e.target !== e.currentTarget) return;
    var obj = $.parseJSON(xhr.responseText);
    successHandler(obj);
  };

  AnswerListener.prototype._addAjaxListener = function(elem, target, handler) {
    elem.on("ajax:success", target, function(e, data, status, xhr) {
      this._onSuccess(e, xhr, handler);
    }.bind(this));
    elem.on("ajax:error", target, function(e, xhr, status, error) {
      this._onMaybeError(e, xhr, status, handler);
    }.bind(this));
  };


  var answerList = new AnswerList(".new_answer_wrapper", ".answers_wrapper");
  var answerListener = new AnswerListener(answerList);
  answerListener.init();

});
