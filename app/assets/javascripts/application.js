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
//= require ckeditor/init
//= require_tree .

window.force_flash = function(flash_element_string) {
    let notification_area = $('#notification-area');
    notification_area.empty().append($(flash_element_string));
};

$(document).ready(function(){
  $("#sort-word-up").click(function(){
    $("#sort-word-down").toggle();
    $("#sort-word-up").toggle();
    $.ajax({
      url: "/organizations/sortable",
      type: get,
      data: type,
      dataType: js
    });
  });
  $("#sort-word-down").click(function(){
    $("#sort-word-down").toggle();
    $("#sort-word-up").toggle();
    $.ajax({
      url: "/organizations/sortable",
      type: get,
      data: type,
      dataType: js
    });
  });
  $("#sort-count-up").click(function(){
    $("#sort-count-up").toggle();
    $("#sort-count-down").toggle();
    $.ajax({
      url: "/organizations/sortable",
      type: get,
      data: type,
      dataType: js
    });
  });
  $("#sort-count-down").click(function(){
    $("#sort-count-up").toggle();
    $("#sort-count-down").toggle();
    $.ajax({
      url: "/organizations/sortable",
      type: get,
      data: type,
      dataType: js
    });
  });
  $("#sort-course-up").click(function(){
    $("#sort-course-up").toggle();
    $("#sort-course-down").toggle();
    $.ajax({
      url: "/organizations/sortable",
      type: get,
      data: type,
      dataType: js
    });
  });
  $("#sort-course-down").click(function(){
    $("#sort-course-up").toggle();
    $("#sort-course-down").toggle();
    $.ajax({
      url: "/organizations/sortable",
      type: get,
      data: type,
      dataType: js
    });
  });
  $("#sort-create-up").click(function(){
    $("#sort-create-up").toggle();
    $("#sort-create-down").toggle();
    $.ajax({
      url: "/organizations/sortable",
      type: get,
      data: type,
      dataType: js
    });
  });
  $("#sort-create-down").click(function(){
    $("#sort-create-up").toggle();
    $("#sort-create-down").toggle();
    $.ajax({
      url: "/organizations/sortable",
      type: get,
      data: type,
      dataType: js
    });
  });
});
