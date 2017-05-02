$(document).ready(function(){


  

  // Sidebar Current URL
  var CURRENT_URL = window.location.href.split('?')[0], 
      $SIDEBAR_MENU = $('.sidebar-menu');
    // check active menu
    $SIDEBAR_MENU.find('a[href="' + CURRENT_URL + '"]').parent('li').addClass('current').parents('li').addClass('open');

    $(".submenu > a").click(function(e) {
      e.preventDefault();
      var $li = $(this).parent("li");
      var $ul = $(this).next("ul");

      if($li.hasClass("open")) {
        $ul.slideUp(350);
        $li.removeClass("open");
      } else {
        $(".nav > li > ul").slideUp(350);
        $(".nav > li").removeClass("open");
        $ul.slideDown(350);
        $li.addClass("open");
      }
    });
  
});