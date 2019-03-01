class SearchController < ApplicationController

  def index
    @owners = Course.search('*').map(&:owner_for_elastic).uniq!
    @difficulties = Course.search('*').map(&:difficulty).uniq!

    if params[:search].presence && params[:search][:query] && params[:difficulty] && params[:owner]
      @results = Course.search_custom(params[:search][:query], params[:difficulty], params[:owner])
    elsif params[:search].presence && params[:search][:query] && params[:difficulty]
      @results = Course.search_custom(params[:search][:query], params[:difficulty])
    elsif params[:search].presence && params[:search][:query] && params[:owner]
      @results = Course.search_custom(params[:search][:query], params[:owner])
    elsif params[:search].presence && params[:search][:query] == ''
      @results = Course.search('*')
    elsif params[:search].presence && params[:search][:query]
      @results = Course.search_custom(params[:search][:query])
    end
  end

  def autocomplete
    auto_params = {}
    if params[:query]
      auto_params[:query] = params[:query]
      auto_params[:difficulty] = params[:difficulty] if params[:difficulty]
      results = AutoCompleteSearch.call(auto_params)
      render json: results.suggest
    end
  end
end
