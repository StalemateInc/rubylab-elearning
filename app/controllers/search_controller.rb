class SearchController < ApplicationController

  skip_before_action :verify_authenticity_token

  # API structure
  # params[:query] - what to look for
  # params[:entity] - where to look for (course, organization)
  # params[:user_id] - for which user to search
  # params[:filters] - filters applied to search
  # params[:filters][:exact_owner] - filter by owner (course only)
  # params[:filters][:difficulty] - filter by difficulty (course only)
  # params[:filters][:visibility] - filter by visibility (course only)
  # params[:filters][:members] - filter by members by id (course only)
  # example: localhost:3000/search?query="foo"&entity=[course,organization]&filters=[difficulty=['intermediate','novice']]
  # this is an JSON action

  def search
    p = params[:search]
    user = User.find_by_id(p[:user_id] || current_user.id)
    return if user.nil? || p[:entity].empty? || p[:query].length < 4 ||  p[:query].empty?
    search_query = p[:query]
    search_entities = []
    p[:entity].each { |entity| search_entities.push(entity.capitalize.constantize) }
    search_filters = {}
    p[:filters]&.each do |filter_key, filter_value|
      case filter_key
      when 'difficulty'
        search_filters[:difficulty] = filter_value
      when 'exact_owner'
        owner_class, owner_id = filter_value
        search_filters[:exact_owner] = "#{owner_class}__#{owner_id}"
      when 'visibility'
        search_filters[:visibility] = filter_value
      when 'members'
        search_filters[:members] = filter_value
      end
    end
    begin
      availability_clause = {
        _or: [
          {
            _type: 'organization',
            state: :verified
          },
          {
            _or: [
              {
                _type: 'course',
                visibility: :everyone
              },
              {
                _and: [
                    {
                      _type: 'course',
                      visibility: [:private, :individuals]
                    },
                    {
                      _type: 'course',
                      accessed_by: p[:user_id]
                    }
                ]
              }
            ]
          }
        ]
      }
      search_filters.merge!(availability_clause) unless user.admin?
      @results = Searchkick.search(search_query,
                                  index_name: search_entities,
                                  fields: [:name, :description, :text_owner],
                                  match: :word_middle,
                                  where: search_filters).results
    rescue Faraday::Error
      @results = []
      search_entities.each do |entity|
        @results.push(entity.sql_full_text_search(p[:query], user))
      end
      @results.flatten!
    end
    respond_to do |format|
      format.json { render json: @results }
      format.js
    end
  end

  def index; end

end
