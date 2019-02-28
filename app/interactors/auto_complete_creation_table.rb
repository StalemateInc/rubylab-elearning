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
              "name": {
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

# $('#main').hide().after('<%= j render "form" %>');
# $('#car_description *').prop('disabled', true);
# $("#make").on('change', function() {
# var make_type = $( "#make option:selected" ).text();
# var first_type = $( "#make option:first" ).text();
# if( make_type != first_type ) {
#   $("#model").prop('disabled', false);
#   console.log(make_type);
#   $.ajax({
#     type:"GET",
#     url:"/cars/models",
#     dataType:"json",
#     data: {make: make_type},
#     success:function(data) {
#       console.log(data);
#       $("#model option").remove();
#       for(var i = 0; i < data.length; i++) {
#         console.log(data[i]);
#         $("#model").append("<option value='" + data[i] +
#          "'>" + data[i] + "</option>");
#       }
#     }
#   })
# } else {
#   $("#model").prop('disabled', true);
#   $("#year").prop('disabled', true);
#   $('#car_description *').prop('disabled', true);
# }
# });

# $("#model").on('click', function() {
# var model_type = $( "#model option:selected" ).text();
# var make_type = $( "#make option:selected" ).text();
# if( model_type != '' ) {
#   $("#year").prop('disabled', false);
#   console.log(model_type);
#   $.ajax({
#     type:"GET",
#     url:"/cars/years",
#     dataType:"json",
#     data: {model: model_type.trim(), make: make_type },
#     success:function(data) {
#       console.log(data);
#       $("#year option").remove();
#       for(var i = 0; i < data.length; i++) {
#         console.log(data[i]);
#         $("#year").append("<option value='" + data[i] +
#          "'>" + data[i] + "</option>");
#       }
#     }
#   })
#   $('#car_description *').prop('disabled', false);
# } else {
#   $("#year").prop('disabled', true);
#   $('#car_description *').prop('disabled', true);
# }
# });
# $("#car_description").on('click', function() {
#   var year = $( "#year option:selected" ).text();
#   $('#purchase').prop('min', year);
# })