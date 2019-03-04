class SearchController < ApplicationController

  # API structure
  # params[:query] - what to look for
  # params[:entity] - where to look for (course, organization)
  # params[:filters] - filters applied to search
  # params[:filters][:exact_owner] - filter by owner (course only)
  # params[:filters][:difficulty] - filter by difficulty (course only)
  # params[:filters][:visibility] - filter by visibility (course only)
  # example: localhost:3000/search?query="foo"&entity=[course,organization]&filters=[difficulty=['intermediate','novice']]
  # this is an JSON action

  def search
    begin
      p = search_params
      search_query = p[:query]
      search_entities = p[:entity].map { |entity| entity.capitalize.constantize }
      search_filters = {}
      p[:filters]&.each do |filter_key, filter_value|
        case filter_key
        when 'difficulty'
          search_filters[:difficulty] = filter_value
        when 'exact_owner'
          owner_class, owner_id = filter_value
          search_filters[:exact_owner] = "#{owner_class}__#{owner_id}"
        end
      end
      results = if params[:filters]
        Searchkick.search search_query,
                          index_name: search_entities,
                          where: search_filters
      else
        Searchkick.search search_query, index_name: search_entities
                end
    rescue Faraday::Error
      # db logic here
      results = []
    end
    respond_to do |format|
      format.json { results.to_json }
    end
  end

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
      @results =  Course.where('name like ? and ', "%#{ruby}%")
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

  private

  def search_params
    params.require(:search).permit(:query, :entity, filters:[])
  end
end
