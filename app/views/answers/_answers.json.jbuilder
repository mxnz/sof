json.cache! ['answers_json', question] do
  json.array! question.answers, partial: 'answer', as: :answer
end
