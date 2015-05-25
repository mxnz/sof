class SearchController < ApplicationController
  respond_to :js

  def index
    search_value = params[:search_value]
    search_domain = params[:search_domain]
    respond_with(@questions = QuestionSearcher.search(search_value, search_domain))
  end
end
