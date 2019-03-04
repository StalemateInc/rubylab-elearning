// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require popper
//= require jquery3
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require select2
//= require rails.validations
//= require rails.validations.simple_form.bootstrap4
//= require bootstrap-multiselect
//= require_tree .

window.force_flash = function(flash_element_string) {
    let notification_area = $('#notification-area');
    notification_area.empty().append($(flash_element_string));
};

$(document).on('turbolinks:load', function() {
  $("#main-search").on('input', function(e) {
    var difficulty = $("#difficulty-search").val();
    console.log(e.target.value);
    console.log(difficulty);
    $.ajax({
      type:"GET",
      url:"/search/autocomplete",
      dataType:"json",
      data: {query: e.target.value, difficulty: difficulty},
      success: function(data) {
        console.log(data);
        if(data) {
          $("#main-search").autocomplete({ source: data });
        }
      }
    }); 
  });
});