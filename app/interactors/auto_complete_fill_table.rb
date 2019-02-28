class AutoCompleteFillTable
  require 'net/http'
  require 'uri'
  require 'json'
  include Interactor

  # Autocomplete fill table

  def call
    begin
      all_courses = Course.where(status: 'published', visibility: 'everyone')
      all_courses.each_with_index do |course, index|
        uri = URI.parse("http://localhost:9200/courses/autocomlete/#{index}")
        request = Net::HTTP::Post.new(uri)
        request.content_type = "application/json"
        request.body = JSON.dump({
          "name": {
            "input": ["#{course.name}"]
          },
          "difficulty": "#{course.difficulty}"
        })

        req_options = {
          use_ssl: uri.scheme == "https",
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
      end
    rescue => e
      context.fail!(message: e)
    end
  end
end
