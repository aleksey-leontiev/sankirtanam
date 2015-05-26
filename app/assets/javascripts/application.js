// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-datepicker
//= require bootstrap-datepicker/locales/bootstrap-datepicker.ru.js
//= require typeahead
//= require jquery.tabletojson
//= require chartist
//= require mindmup-editabletable
//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require_tree .

$(document).ready(function() {
  var embedded = $('body').data("embedded");
  if (embedded) {
    return $("a").each(function() {
      return $(this).attr("href", $(this).attr("href") + "?embedded=true");
    });
  }
});