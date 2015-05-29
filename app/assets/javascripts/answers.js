$(function() {

  function CurrentUser(appData) {
    var app = $(appData);
    this._app = app;

    this.id = app.data("cur_user_id");
    this.signedIn = app.data("cur_user_signed_in");
    this.votes = app.data("cur_user_votes");
  }

  CurrentUser.prototype.owns = function(obj) {
    return obj.user_id === this.id;
  };

  CurrentUser.prototype.votedOnAnswer = function(answer) {
    return this.voteOfAnswer(answer) !== null;
  };

  CurrentUser.prototype.voteOfAnswer = function(answer) {
    for(var i = 0; i < this.votes.length; i++) {
      var vote = this.votes[i];
      if(vote.votable_id === answer.id && vote.votable_type === 'Answer') {
        return vote;
      }
    }
    return null;
  };
  
  //--------------------------------------------------

  function CurrentQuestion(appData) {
    var app = $(appData);
    this._app = app;

    this.id = app.data("question_id");
    this.user_id = app.data("question_user_id");
  }

  //--------------------------------------------------

  function AnswerBuilder(curUser, curQuestion) {
    this.curUser = curUser;
    this.curQuestion = curQuestion;
  }

  AnswerBuilder.prototype.completeAnswer = function(answer) {
    var curUser = this.curUser;
    var signedIn = curUser.signedIn;

    answer.belongs_to_cur_user            = signedIn && curUser.owns(answer);
    answer.question_belongs_to_cur_user   = signedIn && curUser.owns(this.curQuestion);
    answer.can_be_voted_by_cur_user       = signedIn && !curUser.owns(answer);
    answer.voted_by_cur_user              = signedIn && curUser.votedOnAnswer(answer);
    answer.vote_of_cur_user               = signedIn && curUser.voteOfAnswer(answer);

    for(i = 0; i < answer.comments.length; i++) {
      var comment = answer.comments[i];
      comment.belongs_to_cur_user = signedIn && curUser.owns(comment);
    }
  };

  AnswerBuilder.prototype.completeAnswers = function(answers) {
    _.forEach(answers, function(answer) {
      this.completeAnswer(answer);
    }.bind(this));
  };

  //--------------------------------------------------

  function AnswerList(newAnswerWrapper, answersWrapper, appData, curUser) {

    this._answer_form_template = _.template( $("#answer_form_template").html() );
    this._answer_template = _.template( $("#answer_template").html() );
    this._answers_template = _.template( $("#answers_template").html() );
    this._error_messages_template = _.template( $("#error_messages_template").html() );

    this._newAnswerWrapper = $(newAnswerWrapper);
    this._answersWrapper = $(answersWrapper);
    this._newAnswerWrapper.html('<div id="answer_new" />');
    this._app = appData;
    this._curUser = curUser;

    this._newAnswerWrapper.on("click", '#answer_new [data-action="new_answer"]', function(e) {
      e.preventDefault();
      $(e.target).hide();
      this.showAnswerForm();
    }.bind(this));

    this._answersWrapper.on( "click", '.answers .answer [data-action="edit_answer"]', function(e) {
      e.preventDefault();
      $(e.target).hide();
      var answer = $(e.target).closest('.answer').data('answer');
      this.showAnswerForm(answer);
    }.bind(this));

    this._newAnswerWrapper.on('click', '.answer [data-action="cancel_edit_answer"]', function(e) {
      e.preventDefault();
      $(e.target).closest(".answer").find('[data-action="new_answer"]').show();
      this.hideAnswerForm();
    }.bind(this));

    this._answersWrapper.on("click", '.answer [data-action="cancel_edit_answer"]', function(e) {
      e.preventDefault();
      $(e.target).closest(".answer").find('[data-action="edit_answer"]').show();
      var answer = $(e.target).closest('.answer').data('answer');
      this.hideAnswerForm(answer);
    }.bind(this));

    this._initNewAnswer();
  }

  AnswerList.prototype.questionId = function() {
    return parseInt(this._app.data("question_id"));
  };

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
    var answerHtml = this._answer_template({ answer: answer, curUser: this._curUser });
    var answerId = "#answer_" + (answer.id || "new");
    $(answerId).replaceWith(answerHtml);
    $(answerId).data('answer', answer);
  };

  AnswerList.prototype.showAnswers = function(answers) {
    this._answersWrapper.html(this._answers_template( { answers: answers, curUser: this._curUser, answer_template: this._answer_template } ));
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
  
  AnswerList.prototype._createNewAnswer = function() {
    var questionId = this.questionId();
    var userSignedIn = this._app.data("cur_user_signed_in");

    var newAnswer = {
      id: null,
      user_id: null,
      question_id: questionId,
      body: null,
      belongs_to_cur_user: userSignedIn,
      can_be_voted_by_cur_user: false,
      voted_by_cur_user: false,
      vote_of_cur_user: null,
      attachments: []
    };
    return newAnswer;
  };

  AnswerList.prototype._initNewAnswer = function() {
    var newAnswer = this._createNewAnswer();
    this.showAnswer(newAnswer);
  };
  
  //----------------------------------------------------------------

  function AnswerListener(answerList, answerBuilder) {
    this._answerList = answerList;
    this._answerBuilder = answerBuilder;
  }

  AnswerListener.prototype.init = function() {
    this._initAnswers();
    this._addAjaxListenersForErrors();
    this._subscribeToPrivatePub();
  };
   
  AnswerListener.prototype._initAnswers = function() {
    $.getJSON(
      this._answerList.answersPath()
    ).done(function(answers) {
      this._answerBuilder.completeAnswers(answers);
      this._answerList.showAnswers(answers);
    }.bind(this));
  };

  AnswerListener.prototype._addAjaxListenersForErrors = function() {
    this._addAjaxListener(this._answerList.newAnswerWrapper(), "form.new_answer", function(answers) {
    }.bind(this));
    this._addAjaxListener(this._answerList.answersWrapper(), "form.new_answer", function(answer) {
    }.bind(this));
    this._addAjaxListener(this._answerList.answersWrapper(), 'a[data-action="delete_answer"]', function(answer) {
    }.bind(this));
    this._addAjaxListener(this._answerList.answersWrapper(), ".answer_best_false a, .answer_best_true a", function(answers) {
    }.bind(this));
  };

  AnswerListener.prototype._subscribeToPrivatePub = function() {
    var questionId = this._answerList.questionId();
    var channelId = "/questions/" + questionId;

    PrivatePub.subscribe(channelId, function(data, channel) {
      if (data.answer) {
        var answer = $.parseJSON(data.answer);
        if (answer.destroyed) {
          this._answerList.removeAnswer(answer);
        } else {
          this._answerBuilder.completeAnswer(answer);
          this._answerList.showAnswer(answer);
        }
      } else if (data.answers) {
        var answers = $.parseJSON(data.answers);
        this._answerBuilder.completeAnswers(answers);
        this._answerList.showAnswers(answers);
        this._answerList.showAnswer();
      }
    }.bind(this));
  };

  AnswerListener.prototype._onMaybeError = function(e, xhr, status, successHandler) {
    if (e.target !== e.currentTarget || !xhr.responseText) return;
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

  var appData = $("#app_data");
  var curUser = new CurrentUser(appData);
  var curQuestion = new CurrentQuestion(appData);
  var answerBuilder = new AnswerBuilder(curUser, curQuestion);
  var answerList = new AnswerList(".new_answer_wrapper", ".answers_wrapper", appData, curUser);
  var answerListener = new AnswerListener(answerList, answerBuilder);
  answerListener.init();

});
