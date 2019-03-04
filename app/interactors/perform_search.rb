# frozen_string_literal: true

class PerformSearch < BaseInteractor

  # context:
  # params: ActionController:Params, user: User

  # params[:query] - what to look for
  # params[:entity] - where to look for (course, organization)
  # params[:user_id] - for which user to search
  # params[:filters] - filters applied to search
  # params[:filters][:exact_owner] - filter by owner (course only)
  # params[:filters][:difficulty] - filter by difficulty (course only)
  # params[:filters][:visibility] - filter by visibility (course only)
  # params[:filters][:members] - filter by members by id (course only)
  # example: localhost:3000/search?query="foo"&entity=[course,organization]&filters=[difficulty=['intermediate','novice']]

  def call
    p = context.params[:search]
    # user = User.find_by_id(p[:user_id] || current_user.id)
    return if context.user.nil? || p[:entity].blank? || p[:query].length < 4 || p[:query].blank?

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
                    visibility: %i[private individuals]
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
      search_filters.merge!(availability_clause) unless context.user.admin?
      context.results = Searchkick.search(search_query,
                                          index_name: search_entities,
                                          fields: %i[name description text_owner],
                                          match: :word_middle,
                                          where: search_filters).results
    rescue Faraday::Error
      context.results = []
      search_entities.each do |entity|
        context.results.push(entity.sql_full_text_search(p[:query], context.user))
      end
      context.results.flatten!
    end
  end
end