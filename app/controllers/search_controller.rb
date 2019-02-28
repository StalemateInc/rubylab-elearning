class SearchController < ApplicationController

  def index
    
    if params[:search].presence && params[:search][:query] && params[:search][:difficulty]
      @results = Course.search_custom(params[:search][:query], params[:search][:difficulty])
    elsif params[:search].presence && params[:search][:query]
    	@results = Course.search_custom(params[:search][:query])
    end
  end

  def autocomplete
    auto_params = {}
    if params[:search].presence && params[:search][:query]
      auto_params[:query] = params[:search][:query]
      auto_params[:difficulty] = params[:search][:difficulty] if params[:search][:difficulty]
      results = AutoComplete.call(auto_params)
      render json: results.map(&:name)
    end
  end
end
