class AutoCompleteSearch
  require 'net/http'
  require 'uri'
  require 'json'
  include Interactor

  # Autocomplete search
  def call
    begin
      if context.difficulty
        context.difficulty = context.difficulty.split
      else
        context.difficulty = %i[unspecified novice intermediate advanced professional]
      end    
      uri = URI.parse("http://localhost:9200/courses/autocomplete/_search")
      request = Net::HTTP::Get.new(uri)
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
              "field": "name",
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
      context.name = response
    rescue => e
      context.fail!(message: e)
    end
  end
end
