// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require parallax
//= require moment
//= require daterangepicker
//= require_tree .

$( document ).ready(function() {

  $('#workhistoryform').on('hide.bs.collapse', function () {
    $('#addworkhistory_btn').html('Add work history');
    $('#addworkhistory_btn').removeClass('btn-warning');
    $('#addworkhistory_btn').addClass('btn-primary');
  })
  $('#workhistoryform').on('show.bs.collapse', function () {
    $('#addworkhistory_btn').html('Cancel/close');
    $('#addworkhistory_btn').removeClass('btn-primary');
    $('#addworkhistory_btn').addClass('btn-warning');
  });


  $('#daterangepicker').daterangepicker({
    "showDropdowns": true,
    "showWeekNumbers": true,
    "timePickerIncrement": 1,
    "startDate": "07/01/2013",
    "endDate": "08/06/2015",
    "opens": "left",
    "drops": "down",
    "buttonClasses": "btn btn-sm",
    "applyClass": "btn-success",
    "cancelClass": "btn-warning"
  }, function(start, end, label) {
  console.log("New date range selected: ' + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD') + ' (predefined range: ' + label + ')");
 });

});