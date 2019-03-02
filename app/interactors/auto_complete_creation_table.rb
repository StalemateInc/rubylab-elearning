class AutoCompleteCreationTable
  require 'net/http'
  require 'uri'
  require 'json'
  include Interactor

  # Autocomplete create table

  def call
    begin
      
      uri = URI.parse("http://localhost:9200/courses")
      request = Net::HTTP::Put.new(uri)
      request.content_type = "application/json"
      request.body = JSON.dump({
        "mappings": {
          "autocomlete": {
            "properties": {
              "suggest": {
                "type": "completion"
              },
              "difficulty": {
                "type": "keyword"
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
    rescue => e
      context.fail!(message: e)
    end
  end
end
