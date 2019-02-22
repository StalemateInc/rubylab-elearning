class SearchController < ApplicationController
  
  def index
  	if params[:search].presence && params[:search][:query]
      @results = Course.search_published(params[:search][:query])
    end
  end
end
