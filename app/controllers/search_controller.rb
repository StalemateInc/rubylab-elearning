class SearchController < ApplicationController

  def index
    begin
    
      @difficulties = Course.search('*').map(&:difficulty).uniq!
      @owners = Course.search('*').map(&:owner_for_elastic).uniq!

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
    rescue Faraday::ConnectionFailed => e
    	puts e
      @difficulties = Course.pluck(:difficulty).uniq!
      owners_not_uniq = Course.all.map  do |c|
      	name = c.ownership.ownable_type == 'User' ? c.owner.profile.nickname : c.owner.name
        "#{c.ownership.ownable_type} #{name}"
      end
      @owners = owners_not_uniq.uniq!
      @results = Course.all
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
