class SearchController < ApplicationController

  def index
    if params[:search].presence && params[:search][:query]
      @results = Course.search_custom(params[:search][:query])
    end
  end

  def autocomplete
    render json: Course.search(params[:query], autocomplete: true, limit: 10).map(&:name)
  end
end