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
//= require font_awesome5
//= require bootstrap
//= require select2
//= require bootstrap-slider
//= require rails.validations
//= require rails.validations.simple_form.bootstrap4
//= require bootstrap-multiselect
//= require twitter/typeahead.min
//= require jquery.ba-throttle-debounce.min
//= require ckeditor/init
//= require_tree .

window.force_flash = function(flash_element_string) {
    let notification_area = $('#notification-area');
    notification_area.empty().append($(flash_element_string));
};