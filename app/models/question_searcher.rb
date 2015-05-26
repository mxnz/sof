class QuestionSearcher
  DOMAINS = {
    'everywhere' => :everywhere,
    'in questions' => :questions,
    'in answers' => :answers,
    "in questions' comments" => :question_comments,
    "in answers' comments" => :answer_comments
  }

  def self.search(str, domain)
    query = Riddle::Query.escape(str)
    condition = DOMAINS[domain]
    case condition
    when :everywhere
      search_everywhere(query)
    when :questions
      search_in_questions(query)
    else
      search_in_other_domain(query, condition)
    end
  end

  private
    
    def self.search_everywhere(query)
      Question.search(query, index: 'full_questions_index_core')
    end

    def self.search_in_questions(query)
      Question.search(query)
    end

    def self.search_in_other_domain(query, condition)
      Question.search(index: 'full_questions_index_core', conditions: { condition => query })
    end
end
