class AutoCompleteSearch
  require 'net/http'
  require 'uri'
  require 'json'
  include Interactor

  # Autocomplete search

  def call
    begin
      if context.difficulty
        context.difficulty = context.difficulty.flatten!
      else
        context.difficulty = %i[unspecified novice intermediate advanced professional]
      end    
      uri = URI.parse("http://localhost:9200/courses/autocomplete/_search")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request.body = JSON.dump({
        "query": {
          "bool": {
            "filter": {
              "terms": {
                "difficulty": context.difficulty
              }
            }
          }
        },
        "suggest": {
          "course-suggest": {
            "prefix": "#{context.query}",
            "completion": {
              "field": "suggest",
              "fuzzy": {
                "fuzziness": 1
              }
            }
          }
        }
      })

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      parsed = JSON.parse(response.body)

      course_suggest = parsed['suggest']['course-suggest']
        .map {|c| c['options'].map {|e| e['text']}}.flatten!
      context.suggest = course_suggest
    rescue => e
      context.fail!(message: e)
    end
  end
end
