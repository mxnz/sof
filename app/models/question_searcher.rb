class QuestionSearcher
  DOMAINS = [
    ['everywhere', :everywhere],
    ['in questions', :questions],
    ['in answers', :answers],
    ["in questions' comments", :question_comments],
    ["in answers' comments", :answer_comments]
  ]

  def initialize(str, domain)
    @query = Riddle::Query.escape(str)
    @condition = (domain == 'everywhere' || domain == 'questions') ? nil : domain
    @index = (domain == 'everywhere') ? 'full_questions_index_core' : nil
  end

  def search
    if @condition.present?
      Question.search(conditions: { @condition => @query })
    else
      Question.search(@query, index: @index)
    end
  end

  def self.search(str, domain)
    self.new(str, domain).search
  end
end
