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
//= require turbolinks
//= require_tree .

function ready(){
  $("a.user-image-menu").click(function(e){
    e.preventDefault()
    $("div.dropdown-user-menu.parent-menu").toggleClass("opened");
  });
}

function disappear(){
	$('div.flash.flash-notice').delay(3000).fadeOut(1000);
}

function redirectToPage(url){
  $(this).click(function(e){
    if(e.target.id == "purple")
      window.location = url;
  });
}

$(document).ready(function(){
	ready();
	disappear();
});
$(document).on('page:load', function(){
	ready();
	disappear();
});
