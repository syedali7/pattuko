function initToolbarBootstrapBindings() {
    var fonts = ['Serif', 'Sans', 'Arial', 'Arial Black', 'Courier', 
        'Courier New', 'Comic Sans MS', 'Helvetica', 'Impact', 'Lucida Grande', 'Lucida Sans', 'Tahoma', 'Times',
        'Times New Roman', 'Verdana'],
        fontTarget = $('[title=Font]').siblings('.dropdown-menu');
    $.each(fonts, function (idx, fontName) {
        fontTarget.append($('<li><a data-edit="fontName ' + fontName +'" style="font-family:\''+ fontName +'\'">'+fontName + '</a></li>'));
    });
    $('a[title]').tooltip({container:'body'});
    $('.dropdown-menu input').click(function() {return false;})
        .change(function () {$(this).parent('.dropdown-menu').siblings('.dropdown-toggle').dropdown('toggle');})
    .keydown('esc', function () {this.value='';$(this).change();});

    $('[data-role=magic-overlay]').each(function () { 
        var overlay = $(this), target = $(overlay.data('target')); 
        overlay.css('opacity', 0).css('position', 'absolute').offset(target.offset()).width(target.outerWidth()).height(target.outerHeight());
    });
}

function showErrorAlert (reason, detail) {
    var msg='';
    if (reason==='unsupported-file-type') { msg = "Unsupported format " +detail; }
    else {
    }
    $('<div class="alert"> <button type="button" class="close" data-dismiss="alert">&times;</button>'+ 
     '<strong>File upload error</strong> '+msg+' </div>').prependTo('#alerts');
};

$(function(){
    $('#comment-scroll').slimScroll({
        position: 'right',
        height: '120px',
        //height: 'auto',
        railVisible: true
    });
});

$(function(){
    $('#related_movies').slimScroll({
        position: 'right',
        height: '350px',
        railVisible: true
    });
});

$(function(){
    $('#people_involved').slimScroll({
        position: 'right',
        height: '235px',
        railVisible: true
    });
});


$(function() {
 
    // grab the initial top offset of the navigation 
    var header_container_offset_top = $('.header_container').offset().top;
     
    // our function that decides weather the navigation bar should have "fixed" css position or not.
    var header_container = function(){
        var scroll_top = $(window).scrollTop(); // our current vertical position from the top
         
        // if we've scrolled more than the navigation, change its position to fixed to stick to top,
        // otherwise change it back to relative
        if (scroll_top > header_container_offset_top) { 
            $('.header_container').css({ 'position': 'fixed', 'top':0, 'left':0 });
        } else {
            $('.header_container').css({ 'position': 'relative' }); 
        }   
    };
     
    // run our function on load
    header_container();
     
    // and run it again every time you scroll
    $(window).scroll(function() {
         header_container();
    });
 
});

function reloadMasonry($container) {
    if ($container == undefined || $container == null) {
        $container = $('#posts_container');
    }

    if ($container.length == 0) {
        return;
    }

    var params = {itemSelector: '.box', columnWidth: 50};
    var isFitWidth = $container.attr('data-isfitwidth');
    if (isFitWidth == undefined) isFitWidth = true;

    params.isFitWidth = isFitWidth;

    if ($container.attr('data-column-width') != undefined) {
        params.columnWidth = parseInt($container.attr('data-column-width'));
    }

    /*if ($container.length == 0) {
        $container = $("#related_posts_container");
    }*/

    $container.masonry(params);
}

function load_notify() {
    $("#notify-container").notify();

    $("#notify-container").notify("create", {
      title: 'Clapped Succesfully',
      text: 'You will be rewarded soon'
    });
}

//$(window).load(function() {
    /*var trip = new Trip([
        {
            sel : $('.widget_container'), 
            position : 'n', 
            content : 'Everything about the movies and the news in movie world', 
            delay : 3000,
            showNavigation: true,
            expose : true,
            showCloseBox: true
        },
        {
            sel : $('li:first', '.navigation_menu'),
            position : 's',
            content : 'Your feed with list of posts are here',
            delay : 2000,
            showNavigation: true,
            showCloseBox: true
        },
        {
            sel : $('.box:first', "#container"),
            position : 'e',
            content : 'Image says 1000 words and its all about the news',
            delay : 3000,
            showNavigation: true,
            expose : true,
            showCloseBox: true
        },
        {
            sel: $(".movie_cmts:first", "#container"),
            position: 'e',
            content: "As soon as you find interesing clap the post, you will be rewarded",
            delay: 3000,
            showNavigation: true,
            expose: true,
            showCloseBox: true
        },
        {
            sel: $(".widg_fb_icon"),
            position: 'e',
            content: "Lets start the game by logging in with Facebook",
            delay: 3000,
            showNavigation: true,
            expose: true,
            showCloseBox: true
        }
    ], {
        tripTheme : "black",
        onTripStart : function() {
            console.log("onTripStart");
        },
        onTripEnd : function() {
            console.log("onTripEnd");
        },
        onTripStop : function() {
            console.log("onTripStop");
        },
        onTripChange : function(index, tripBlock) {
            console.log("onTripChange");
        },
        backToTopWhenEnded : true,
        delay : 2000
    });


var user_trip = new Trip([
{
    sel : $('li:first', '.navigation_menu'),
    position : 's',
    content : 'Your feed with list of posts are here',
    delay : 3000,
    showNavigation: true,
    showCloseBox: true
},
{
    sel : $('.box:first', "#container"),
    position : 'e',
    content : 'Image says 1000 words and its all about the news',
    delay : 4000,
    showNavigation: true,
    expose : true,
    showCloseBox: true
},
{
    sel: $(".movie_cmts:first", "#container"),
    position: 'e',
    content: "As soon as you find interesing clap the post, you will be rewarded",
    delay: 4000,
    showNavigation: true,
    expose: true,
    showCloseBox: true
}
], {
    tripTheme : "black",
    onTripStart : function() {
        console.log("onTripStart");
    },
    onTripEnd : function() {
        console.log("onTripEnd");
    },
    onTripStop : function() {
        console.log("onTripStop");
    },
    onTripChange : function(index, tripBlock) {
        console.log("onTripChange");
    },
    backToTopWhenEnded : true,
    delay : 2000
});*/
/*$(document).ready(function(){
    if ($.cookie('first_time') == undefined ){
        trip.start(); 
        $.cookie('first_time', true);
    }
});*/

/*$(".take_tour").click(function() {
    if (window.location.pathname != "/") {
        $.removeCookie('first_time');
        window.location = "/";
    } else {
        trip.start();
    }
});


/*jQuery(window).bind(
    "beforeunload", 
    function() { 
        $('.feedback-fancybox').fancybox().trigger('click');
    }
});*/

/*window.trip = trip;

*/
/*function addToolTips() {
    $("div.box").each(function() {
        if ($("div.movie_circle_connected", $(this)).length == 0) {
            $(this).qtip({ // Grab some elements to apply the tooltip to
                overwrite: false,
                content: {
                    text: 'If you like this post "CLAP" it. You will get the 5 points on successful clap. <a href="/clap.html">Learn More</a>'
                },
                style: {
                    classes: 'qtip-rounded'
                },
                position: {
                    my: 'left center',  // Position my top left...
                    at: 'right center', // at the bottom right of...
                    target: $(".hover-section", $(this)) // my target
                },
                hide: {
                    fixed: true,
                    leave: false
                }
            });
        }
    });
}*/

$(document).ready(function() {
    //jQuery("time.timeago").timeago();


    //filter script starts
    /*$('.filter_icon').toggle(function(){
        $('.filter_inner').slideUp(350);
    },function(){
        $('.filter_inner').slideDown();
    });*/
    
    
    /*$(".filter_inner > li > a").on("click", function(e){
        if($(this).parent().has("ul")) {
          e.preventDefault();
        }
        
        if(!$(this).hasClass("open")) {
          // hide any open menus and remove all other classes
          $(".filter_inner li ul").slideUp(350);
          $(".filter_inner li a").removeClass("open");
          
          // open our new menu and add the open class
          $(this).next("ul").slideDown(350);
          $(this).addClass("open");
        }
        
        else if($(this).hasClass("open")) {
          $(this).removeClass("open");
          $(this).next("ul").slideUp(350);
      }
  });*/

    //filter script ends

    // artist show page script starts
    var win_height = $(window).height();
    $("img", ".artist_image_part").attr('height', win_height - 128);
    //alert(win_height);
    //$('.artist_container').css('height',win_height-53'px');
    //$('.artist_desc_area').css('height',win_height-128+'px');
    

    // artist show page script ends


    var $container = $('#container');

    var $shop_container = $('#shop-container');

    if ($("ul.movie_items", $container).length > 0) {
        $container = $("ul.movie_items", $container);
    }

    if ($("ul.artists_items", $shop_container).length > 0) {
        $shop_container = $("ul.artists_items", $shop_container);
    }

    $shop_container.masonry({
        itemSelector: '.shop-box',
        columnWidth: 50,
        isFitWidth: true
    });

    reloadMasonry($container);
    
    $('.comment_area textarea').click(function(){
        $('.comment_btn').css("display","block");
    });

    // do the images lazy load
    $("img.lazy").lazyload().removeClass("lazy");

    if ($container.length != 0) {
    }

    if ($shop_container.length != 0) {
        $shop_container.infinitescroll({
            navSelector  : 'div.pageless-navigation',  
            nextSelector : 'div.pageless-navigation a:first',  
            itemSelector : '.shop-box',     
            extraScrollPx: 1000,
            loading: {
                finishedMsg: 'No more styles to load.',
                img: 'http://i.imgur.com/6RMhx.gif'
            },
            bufferPx: 100,
            extraScrollPx: 100
        }, function( newElements ) {
            var $newElems = $( newElements ).css({ opacity: 0 });
            $newElems.animate({ opacity: 1 });
            $shop_container.masonry( 'appended', $newElems, true );

            // do the images lazy load
            $("img.lazy").lazyload().removeClass("lazy");

        });
    }


    //var user_id = parseInt($('.user_id').html());

    /*if( (user_id != user_id) && ($.cookie('the_cookie') == null) ) {
        $(".wood-selection-fancybox").fancybox({
            'closeBtn' : false,
            keys : {
                close  : null
            },
            helpers : {
                overlay: {
                    locked: false,
                    closeClick: false
                }
            }
        });/*.trigger('click');
    }*/

    /*if( (user_id != user_id) && ($.cookie('the_cookie') == null) ) {
        $(".wood-selection-fancybox").fancybox({
            'closeBtn' : false,
            keys : {
                close  : null
            },
            helpers : {
                overlay: {
                    locked: false,
                    closeClick: false
                }
            }
        });/*.trigger('click');
    }*/


    //scroll to top intially hidden
    $("#ScrollToTop").hide();

    $(window).scroll(function () {
        if ($(this).scrollTop() > 100) {
            $('#ScrollToTop').fadeIn();
        } else {
            $('#ScrollToTop').fadeOut();
        }
    });

    $('#ScrollToTop').click(function () {
        $('body,html').animate({
            scrollTop: 0
        }, 800);
        return false;
    });

    /*$(".fancybox").fancybox({
        helpers : {
            overlay: {
                locked: false
            }
        }
    });

    $(".fancybox-show").fancybox({
        helpers : {
            overlay: {
                locked: false
            }
        }
    });


    

    $(".fancybox-new").fancybox({
        afterShow: function() {
            initToolbarBootstrapBindings();  
            $('#editor').wysiwyg();
        }
    });

    $(".fancybox-shop-edit").fancybox();
    
    $('.fancybox-buttons').fancybox({
        openEffect  : 'none',
        closeEffect : 'none',

        prevEffect : 'none',
        nextEffect : 'none',

        closeBtn  : false,

        helpers : {
            thumbs  : {
                width   : 100,
                height  : 50
            },
            
            buttons : {},
            overlay: {
                locked: false
            }
        },

        afterLoad : function() {
            this.title = 'Image ' + (this.index + 1) + ' of ' + 
            this.group.length + (this.title ? ' - ' + this.title : '');
        }
    });

    $(".various").fancybox({
        maxWidth    : 800,
        maxHeight   : 600,
        fitToView   : false,
        width       : '70%',
        height      : '70%',
        autoSize    : false,
        closeClick  : false,
        openEffect  : 'none',
        closeEffect : 'none',
        helpers : {
            overlay: {
                locked: false
            }
        }
    });*/
    

    /*$(".comnt-btn").click(function(){
        var text = $('textarea',$(this).closest('form')).val();
        var post_id = $("textarea",$(this).closest('form')).parent().attr('id').split('-')[1];
        var user_id = parseInt($('.user_id').html());
        if ( text == "" || text == " ") {
            alert("Enter the comment");
        }
        else {
            $.ajax({
                type : 'POST',
                url: '/posts/'+ post_id +'/comments',
                data : { content : text, post_id : post_id, user_id : user_id },
                success: function() {
                    $.ajax({
                        url : "/posts/" + post_id +"/load_comments",
                        success : function(data){
                            $('#comment-list-' + post_id).html(data);
                            reloadMasonry();
                        }
                    })
                }
            });
        }
    });

    $(".img-comnt-btn").click(function(){
        var text = $('textarea',$(this).closest('form')).val();
        var img_id = $("textarea",$(this).closest('form')).parent().attr('id').split('-')[1];
        var user_id = parseInt($('.user_id').html());
        if ( text == "" || text == " ") {
            alert("Enter the comment");
        }
        else {
            $.ajax({
                type : 'POST',
                url: '/images/'+ img_id +'/comments/image_comment_create',
                data : { content : text, img_id : img_id, user_id : user_id },
                success: function() {
                    $.ajax({
                        url : "/images/" + img_id + "/load_image_comments",
                        success : function(data){
                            $('#comment-list-' + img_id).html(data);
                            reloadMasonry();
                        }
                    })
                }
            });
        }
    });*/

    //home page post description on the hover

    /*$("#container").delegate("div[id^='fan-section-']","hover",function(){*/
    $("#container").delegate(".hover-section","hover",function(){
        /*var post_id = $(this).attr('id').split('-')[2];*/
        var post_id = $(this).attr('data-id');
        var content = $('#hover-content-' + post_id).html().trim();
        if (content == '') {
            $.ajax({
                type : 'GET',
                url: '/posts/' + post_id + '/hover_content',
                data : { post_id : post_id },
                success: function(data) {
                    $('#hover-content-' + post_id).html(data);
                }
            });
        }
    });

        //addToolTips();

    /*show page comment*/

    $('.showpage-comment').keydown(function (e){
        var text = $(this).val();
        var post_id = $(this).attr('id');
        var user_id = parseInt($('.user_id').html());
        var trimtext = text.trim();
        if(e.keyCode == 13){
            if (trimtext == "") {
                alert("please enter the comment");
            }
            else {
                $(this).val('');
                $('.comment_scroll').html("<img src='http://www.traceinternational.org/images/loading4.gif' style ='height:50px;" +
                                    "width:50px;'/>");
                $.ajax({
                    type : 'POST',
                    url: '/posts/show_page_comment',
                    data : { content : text, post_id : post_id, user_id : user_id },
                    success: function() {
                        $.ajax({
                            url : "/posts/" + post_id +"/load_show_page_comments",
                            success : function(data){
                                $('.comment_scroll').html(data);
                            }
                        });

                    }
                });

                return false;
            }
        }
    }); 

    //Home page comment

    $("#container").delegate(".homepage-comment","keydown",function(e){
        var text = $(this).val();
        var post_id = $(this).attr('id');
        var user_id = parseInt($('.user_id').html());
        var trimtext = text.trim();
        var img = $('img','.header_user_icon').attr('src');
        if(e.keyCode == 13){
            if (trimtext == "") {
                alert("please enter the comment");
            }
            else {
                $('#post_replace-'+ post_id).html("<figure class='float_L'><img src =" + img +' height=30 width=30></figure>'
                                     + "<label>"+text+"<br/>"+"<a class='simple' href='javascript:void(0)' id='like-'" +
                                    post_id + '-' + user_id + ">Like</a></label>").show();

                 $('#container').masonry({
                              itemSelector: '.box',
                              columnWidth: 50,
                              isFitWidth: true
                            });
                 reloadMasonry();
                $(this).val('');
                $.ajax({
                    type : 'POST',
                    url: '/posts/home_page_comment',
                    data : { content : text, post_id : post_id, user_id : user_id },
                    success: function() {
                        $.ajax({
                            url : "/posts/" + post_id +"/load_home_page_comments",
                            success : function(data){
                                $('#post-description-' + post_id ).html(data);
                                $('#container').masonry({
                                  itemSelector: '.box',
                                  columnWidth: 50,
                                  isFitWidth: true
                                });
                            }
                        });

                    }
                });

                return false;
            }
        }
    });


    $("#container").delegate("input[id^='fan-follow_']","click",function(){
        var post_id = $(this).attr('id').split('_')[1]
        var user_id = parseInt($('.user_id').html());
        var element = $(this);
        $.ajax({
            type : 'POST',
            url : '/posts/fan_follow',
            data : { post_id : post_id, user_id : user_id },
            beforeSend:  function(){
                element.val("Adding");
            },
            failure: function(){
                element.val("I'm Fan");
            },
            success: function(data) {
                element.remove();
                $.ajax({
                    type : 'GET',
                    url : '/posts/' + post_id +'/load_fans_count',
                    data : { post_id : post_id, user_id : user_id },
                    success :function(data) {
                        $('#fans-count-' + post_id).html(data);
                    }
                });
            }
        });
        return false;
    });

    //show page clap
    
    $("a[id^='clap-']").click(function(){
        var post_id = $(this).attr('id').split('-')[1];
        //var user_id = parseInt($('.user_id').html());
        $("#clap-" + post_id).html("clapped");
        $.ajax({
            type : 'POST',
            url : '/posts/clap',
            data : { post_id : post_id},
            success: function(data) {
                reloadMasonry();
            }
        });
    });

    //home page clap

    $("#container").delegate("a[id^='home-page-clap-']","click",function(){
        var post_id = $(this).attr('id').split('-')[3];
        //var user_id = parseInt($('.user_id').html());
        $("#home-page-clap-" + post_id).html("Clapped");
        $('#fan-section-' + post_id).addClass('movie_circle_connected');

        //notification 
        load_notify();

        $.ajax({
            type : 'POST',
            url : '/posts/clap',
            data : { post_id : post_id},
            success: function() {
                $.ajax({
                    url : "/posts/" + post_id +"/load_home_page_comments",
                    success : function(data){
                        $('#post-description-' + post_id ).html(data);
                        reloadMasonry();
                    }
                });
            }
        });   
    });


    //home page clap for icon change
    $("#container").delegate("div.movie_circle", "click", function(event) {
        if ($(event.target).attr('id').indexOf("fan-section-") >= 0) {
            post_id = $(this).attr('id').split('-')[2];
            $('#fan-section-' + post_id).addClass('movie_circle_connected');
            $("#home-page-clap-" + post_id).html("Clapped");

            //notification
            load_notify();

            var user_id = parseInt($('.user_id').html());
            $.ajax({
                type : 'POST',
                url : '/posts/clap',
                data : { post_id : post_id },
                success: function() {
                    $.ajax({
                        url : "/posts/" + post_id +"/load_home_page_comments",
                        success : function(data){
                            $('#post-description-' + post_id ).html(data);
                            reloadMasonry();
                        }
                    });
                }
            });
        }
    });

    //shop show page clap

    $('#style-clap').click(function(){
        style_id = $(this).attr('data-id');

        $(this).hide();

        //notification 
        load_notify();

        $.ajax({
            type : 'POST',
            url : '/shop/style_clap',
            data : { style_id : style_id}
        });

    });


    //header recently viewed news loading
    if ($.trim($('#recently_viewed_news').html()) == "") {
        $.ajax({
            type : 'GET',
            url : '/posts/recently_viewed_news',
            success: function(data) {
                $('#recently_viewed_news').html(data);
            }
        });
    }

    //header recently viewed posts loading
    if ($.trim($("#recently_viewed_posts").html()) == "") {
        $.ajax({
            type : 'GET',
            url : '/posts/recently_viewed_posts',
            success: function(data) {
                $('#recently_viewed_posts').html(data);
            }
        });
    }

    //polling
    $('.polling').hide();

    $('.post_poll_button').hide();

    $('.answer-options').hide();

    $("a[id^='question-']").click(function(){
        var post_id = $(this).attr('id').split('-')[1];
        $('#textfield-' + post_id).show();
        $('#answer-options-' + post_id).show();
        $('#post_poll_button-' + post_id).show();
    });

    $("button[id^='post_poll_button-']").click(function(){
        var post_id = $(this).attr('id').split('-')[1];
        var question = $('#question_text-' + post_id).val();
        var posting_id = parseInt($('.posting_id').html());
        var posting_type = $('.posting_type').html().trim();
        var count = 0;
        var options = '';
        for( i=0; i<4; i++){
            options = options + '|' + $('#answer_text-' + count).val();
            count = count + 1;
        }

        $.ajax({
            type : 'POST',
            url : '/posts/polling',
            data : { posting_id : posting_id,  posting_type : posting_type, options : options, question : question },
            success : function(){
                $('#poll_success_response').html("Question posted succesfully..");
            }
        });
    });

    /*$(window).unload(function() {
      alert('Handler for .unload() called.');
    });*/

    /*rating in movies
    $("input[id^='star-']").click(function(){
        
        var movie_id = $(this).attr('id').split('-')[2];
        var user_id = $(this).attr('id').split('-')[3];
        
        $.ajax({
            type : 'POST',
            url : '/movies/movie_ratings',
            data : { rating : rating, user_id : user_id, movie_id : movie_id },
            
        });
    });*/
    /*clap*/

    /*$(".dropdown").hide();


    $(".box").delegate(".hoverDiv", "mouseenter", function(){
        var post_id = $(this).attr('data-post-id');
        $('#clap-' + post_id).show();
    });

    $(".box").delegate(".hoverDiv", "mouseleave",function(){
        var post_id = $(this).attr('data-post-id');
        $('#clap-' + post_id).hide();
    });

    $(".box").delegate("img[id^='clap-']","click",function(){
        post_id = $(this).attr("id").split('-')[1];
        alert(post_id);
    });*/

    //movie index page fan following

    $("input[id^='index-movie-fan']").live('click', function(){
        var user_id = $(this).attr('data-id').split('-')[1];
        var movie_id = $(this).attr('data-id').split('-')[0]; 
        var element = $(this);
        $.ajax({
            type : 'POST',
            url : '/movies/movie_fan',
            data : { movie_id : movie_id, user_id : user_id },
            beforeSend: function() {
                element.val("Adding");
            },
            success: function() {
                element.remove();
            },
            failure: function() {
                element.val("I'm Fan");
            }
        });

        return false;
    });

    //artist index page fan following

    $("input[id^='index-artist-fan']").live('click', function(){
        var user_id = $(this).attr('data-id').split('-')[1];
        var artist_id = $(this).attr('data-id').split('-')[0]; 
        var element = $(this);
        $.ajax({
            type : 'POST',
            url : '/artists/artist_fan',
            data : { artist_id : artist_id, user_id : user_id },
            beforeSend: function() {
                element.val("Adding");
            },
            success: function() {
                element.remove();
            },
            failure: function() {
                element.val("I'm Fan");
            }
        });

        return false;
    });

    
    
    /*artist fan post show page*/

    $("input[id^='artist-']").click(function(){ });
     /*artist fan post show page with more option ajax call*/
     
    $('.show_popup_cont_rgt').delegate(".involved input[id^='artist-']","click", function(){
        var artist_id = $(this).attr('id').split('-')[1];
        var user_id = $(this).attr('id').split('-')[2];
        var element = $(this);
        $.ajax({
            type : 'POST',
            url : '/artists/artist_fan',
            data : { artist_id : artist_id, user_id : user_id },
            beforeSend: function() {
                element.val("Adding");
            },
            success: function() {
                element.remove();
            },
            failure: function() {
                element.val("I'm Fan");
            }
        });  
        return false;  
    });


    //movie fan in post show page with ajax call

    $('.show_popup_cont_rgt').delegate(".involved input[id^='movie-']","click", function(){
        var movie_id = $(this).attr('id').split('-')[1];
        var user_id = $(this).attr('id').split('-')[2];
        var element = $(this);
        $.ajax({
            type : 'POST',
            url : '/movies/movie_fan',
            data : { movie_id : movie_id, user_id : user_id },
            beforeSend: function() {
                element.val("Adding");
            },
            success: function() {
                element.remove();
            },
            failure: function() {
                element.val("I'm Fan");
            }
        });
        return false;  
    });

    /*movie fan post show page*/

    $("input[id^='movie-']").click(function(){
        var movie_id = $(this).attr('id').split('-')[1];
        var user_id = $(this).attr('id').split('-')[2];
        var element = $(this);
        if (user_id == null) {
            //alert("Kindly login to become a fan");
        }
        else {
            $.ajax({
                type : 'POST',
                url : '/movies/movie_fan',
                data : { movie_id : movie_id, user_id : user_id },
                beforeSend:  function(){
                    element.val("Adding"); 
                },
                success: function(){
                    $.ajax({
                        type : 'POST',
                        url : '/movies/load_moviefans_count',
                        data : { movie_id : movie_id },
                        success: function(data){
                            $("#load_fans").html(data)
                        }
                    });
                    element.remove();
                },
                failure: function(){
                    element.val("I'm Fan");
                }
            });  
        }
    });

    //cover photo change in post show page

    $('.cover-photo-change').click(function(){
        var image_id = $(this).attr('data-image-id');
        var album_id = $(this).attr('data-album-id');
        var post_id = $(this).attr('data-post-id');
        var element = $(this);
        $.ajax({
            type : 'POST',
            url : '/posts/album_cover_image_change',
            data : { image_id : image_id, album_id : album_id, post_id : post_id},
            success: function(){
                element.remove();
            }
        });

    });

    //edit of the post at the post show page
    $('#post_edit_submit').click(function(){
        var post_id = $(this).attr("data-id");
        var title = $('#title_edit').val();
        var news_content = $('#news_edit').val();
        var show_path = $(this).attr("data-show-path");
        var image_url = $('#image_url').val();
        var image_id = $('#edit_post_image').find('img').attr('data-id');
        var element = $(this);

        $('#post_image_update').html("Please wait.... Image downloading under progress.. \n Don't refresh the page");
        $.ajax({
            type : 'POST',
            url : '/posts/post_edit',
            data : { post_id : post_id,title : title, news_content : news_content, image_id : image_id, image_url:image_url},
            success: function(){
                window.location.href = show_path;                
            } 
        });
    });

    //static movie fan in header

    $("#header-fan").click(function(){
        var element = $(this);
        element.val("Adding");
        element.remove();
    });

    $("#header-fan1").click(function(){
        var element = $(this);
        element.val("Adding");
        element.remove();
    });
    $("#header-fan3").click(function(){
        var element = $(this);
        element.val("Adding");
        element.remove();
    });

    $("#header-fan4").click(function(){
        var element = $(this);
        element.val("Adding");
        element.remove();
    });
    $("#header-fan5").click(function(){
        var element = $(this);
        element.val("Adding");
        element.remove();
    });

    $("#header-fan6").click(function(){
        var element = $(this);
        element.val("Adding");
        element.remove();
    });
    $("#header-fan7").click(function(){
        var element = $(this);
        element.val("Adding");
        element.remove();
    });

    $("#header-fan8").click(function(){
        var element = $(this);
        element.val("Adding");
        element.remove();
    });

    
    $("#container").delegate("a#trusted","click",function(){
    //$('a#trusted','li').click(function(){
        var post_id = parseInt($(this).attr('data_id'));
        var self=this
        $.ajax({
            type : 'POST',
            url : 'posts/trusted',
            data : { post_id : post_id},
            success: function(data){
                if(data=='untrusted'){
                    $('#post-trusted-' + post_id).html(' <img class="ribben" src="/assets/ribben.png" width="30" height="37"> ');
                    $(self).text(data);
                }
                else{
                    $('#post-trusted-' + post_id).html('');
                    $(self).text(data);
                }    
            },
            failure: function() {
                alert("error in trusting post... try again later");
            }
        });
    });

    /*artist fan artist show page*/

    $("input[id^='artist-']").live('click',function(){
        var artist_id = $(this).attr('id').split('-')[1];
        var element = $(this);
        $.ajax({
            type : 'POST',
            url : '/artists/artist_fan',
            data : { artist_id : artist_id},
            beforeSend:  function(){
                element.val("Adding");
            },
            success: function(){
                element.remove();
            },
            failure: function(){
                element.val("I'm Fan");
            }
        });  
    });

    $(document).keyup(function(e) {
        if (e.keyCode == 27) { 
            $(".show_post_popup").css("overflow-y", "hidden");
            $("html").css('overflow-y', "scroll");
            $(".show_post_popup").hide();
            history.pushState({}, '', '/');
        }
    });

    //post show page navigation

    $('.next_post').live('click',function(){
        var data_url = $(this).attr('data-post-id');
        if (data_url == undefined || data_url == null) {
            alert("No Post exists");
        }
        else {
            post_show(data_url);
        }
        
    });

    $('.previous_post').live('click',function(){
        var data_url = $(this).attr('data-post-id');
        if (data_url == undefined || data_url == null) {
            alert("No Post exists");
        }
        else {
            post_show(data_url);
        }
    });

    $("a[id^='cast&crew-']").click(function(){
        $( this ).css( "color", "red" );
        $(".newclass1").css("color","white");
        $(".newclass3").css("color","white");
        $(".newclass4").css("color","white");
        $(".reviews_show").hide();
        $('.reviews_show').hide();
        var movie_id = $(this).attr('id').split('-')[1];
        $.ajax({
            type : 'POST',
            url : '/movies/cast_crew',
            data : { movie_id : movie_id },
            success: function(data) {
                $(".movie").html(data).show();
            
            },
        });
    });

    /*related movie fan in movie show page*/

    $("#related_movie_fan").live('click', function(){
        var element = $(this);
        var movie_id = $(this).attr("data-movie-id");
        $.ajax({
            type : 'POST',
            url : '/movies/movie_fan',
            data : { movie_id : movie_id },
            beforeSend:  function(){
                element.val("Adding");
            },
            success: function(){
                element.remove();
            },
            failure: function(){
                element.val("I'm Fan");
            }
        });

    });


     /*artists fan action in movie page*/

    $("input[id^='artist_fans-']", 'li').live('click', function(){
        consle.log("casd");
        var artist_id= $(this).attr('id').split('-')[1];
        var current_user_id = $(this).attr('id').split('-')[2];
            var element = $(this);
            $.ajax({
                type : 'POST',
                url : '/artists/artist_fan',
                data : { artist_id : artist_id, user_id : current_user_id },
                 beforeSend:  function(){
                    element.val("Adding");
                },
                success: function(){
                    $.ajax({
                        type : 'POST',
                        url : '/movies/load_artistfans_count',
                        data : { artist_id : artist_id },
                        success: function(data){
                            $("#load_artistfans-"+artist_id).html(data)
                        }
                    });
                    element.remove();
                },
                failure: function(){
                    element.val("I'm Fan");
                }
            });  
        return false;   
    });

    $("a[id^='photos-']").click(function(){
        $(".reviews_show").hide();
        $( this ).css( "color", "red" );
        $(".newclass1").css("color","white");
        $(".newclass2").css("color","white");
        $(".newclass3").css("color","white");
        var movie_id = $(this).attr('id').split('-')[1];
        $.ajax({
            type : 'POST',
            url : '/movies/photos',
            data : { movie_id : movie_id },
            success: function(data) {
            $(".movie").html(data).show();
                setTimeout(function() {
                    reloadMasonry();    
                }, 500);
            
             },
        });
    });

    $("a[id^='activities-']").live('click', function(){
        $(".reviews_show").hide();
        $(this).css( "color", "red" );
        $(".newclass2").css("color","white");
        $(".newclass3").css("color","white");
        $(".newclass4").css("color","white");
        var movie_id = $(this).attr('id').split('-')[1];
        $.ajax({
            type : 'GET',
            url : '/movies/' + movie_id+ '/activities',
            data : { movie_id : movie_id },
            success: function(data) {
                $(".movie").html(data).show();
                setTimeout(function() {
                    reloadMasonry();
                }, 500);
            }
        });
    });

    $('.review-form').hide();


    /*comment like in post show*/


    $("#comment-scroll").delegate(".float_L a[id^=like-]","click", function(){
        user_id = $(this).attr('id').split('-')[2];
        comment_id = $(this).attr('id').split('-')[1];
        $(this).html("Liked");
        $.ajax({
            type : 'POST',
            url : '/comments/comment_like',
            data : { comment_id : comment_id, user_id : user_id }
        });
    });

    /*comment delete in post show*/
    
    $('#comment-scroll').delegate(".float_L a[id^=delete-]","click", function(){
        var user_id = $(this).attr('id').split('-')[2];
        var comment_id = $(this).attr('id').split('-')[1];
        var post_id = $(this).attr('id').split('-')[3];
        $('.comment_scroll').html("<img src='http://www.traceinternational.org/images/loading4.gif' style ='height:50px;" +
                                    "width:50px;'/>");
        $.ajax({
            type : 'POST',
            url : '/comments/comment_delete',
            data : { comment_id : comment_id},
            success: function() {
                $.ajax({
                    url : "/posts/" + post_id +"/load_show_page_comments",
                    success : function(data){
                        $('.comment_scroll').html(data);
                    }
                })
            }
        });

    });

    /*more link for people involved*/
    $("a[id^='more-']").click(function(){
        var post_id = $(this).attr('id').split('-')[1];
        $.ajax({
            url : "/posts/" + post_id +"/more_people_involved",
            success : function(data){
                $('.involved').html(data);
                $('#more-' + post_id).hide();
                $('#people_involved').slimScroll({
                    position: 'right',
                    height: '235px',
                    railVisible: true
                });
            }
        })
    });
    


    /* more links for related_movies*/

    $("a[id^='more_relatedmovies-']").click(function(){
        var movie_id = $(this).attr('id').split('-')[1];
        $(this).hide();
        $.ajax({
             type : 'GET',
              url : '/movies/' + movie_id+ '/relatedmovies',
             data : { movie_id : movie_id },
            success : function(data){

                $('#related_movies').html(data);
               $('#related_movies').slimScroll({
                    position: 'right',
                    height: '235px',
                    railVisible: true
                });
                
            }
        })
    });

    /*login facebook to show fans*/
    $("a[id^='fb_hide-']").click(function(){
        var movie_id = $(this).attr('id').split('-')[1];
        $.ajax({
            type : 'POST',
            url : '/movies/fans',
            data : { movie_id : movie_id },
            success: function(data) {
            
            
        },
        });
    });

    //selecting image randomly and add album

    $('.create-album').live('click',function(){
        var image_ids = [];
        $('.image-select:checked').each(function(){
            image_id = $(this).val();
            image_ids.push(image_id);
        });
        //alert(image_ids);
        var url = '/images/images_select_album_create_render?';
        $.each(image_ids, function(index, value){
            url = url + 'image_ids[]=' + value + '&';
        });
        window.open(
          url,
          '_blank' 
        );
    });
    
    /*var mentions = [];
    var images = [];
    /*$('#textarea3').textcomplete({
    html: {
        match: /\B@(\w*)$/,
        search: function (term, callback) {
            
           $.ajax({    
                type : 'POST',
                url: '/movies/autocompleat_movie.json',
                data : { q  : term},
                success: function(data) {
                    var dat = data;
                    var sz = dat.movies.length;
                    for(var i = 0; i < sz; i++){

                        mentions[i] = dat.movies[i].name;
                        console.log(mentions);
                        images[i] = dat.movies[i].movie_image;
                        console.log(images);

                    }
                    callback($.map(mentions, function (movies) {
                    return movies.indexOf(term) === 0 ? movies : null;
                }));
                   
                }
            });

        },
        index: 1,
        template: function (value) {
            return '<img src="http://d154rvuufl6jl1.cloudfront.net/uploads/movie/movie_image/3/3-' + value + '.jpg"></img>' + value;
        },
        replace: function (movies) {
            return '@' + movies + '';

        }
    }
    }).overlay([
        {
            match: /\B@\w+/g,
            css: {
                'background-color': '#d8dfea'
            }
        }
    ]);*/

    //to mention artist and movie to store their particular ids in hiiden field in form
    $('#mention_artist_select_dropdown').click(function(){
        $("input[name='mention_artist_id']").val($('#mention_artist_select_dropdown').val());
    });

    $('#mention_movie_select_dropdown').click(function(){
        $("input[name='mention_movie_id']").val($('#mention_movie_select_dropdown').val());
    });

    $('#movie-select').click(function(){
        alert('movie')
        $('#sub_edit_movie').show();
        $('#sub_edit_artist').hide();
        $('#sub_edit_event').hide();
    });

    $('#artist-select').click(function(){
        $('#sub_edit_movie').hide();
        $('#sub_edit_artist').show();
        $('#sub_edit_event').hide();
    });

    $('#event-select').click(function(){
        $('#sub_edit_movie').hide();
        $('#sub_edit_artist').hide();
        $('#sub_edit_event').show();
    });

    $('.comment_area textarea').click(function(){
        $('.comment_btn').css("display","block");
    });

    $('.star_rating').rating(function(vote, event){
         //var m = vote;
         var rating = vote.split('-')[1];
         var movie_id = vote.split('-')[2];
         var user_id = vote.split('-')[3];
        $.ajax({
            type : 'POST',
            url : '/movies/movie_ratings',
            data : { movie_id : movie_id, rating : rating, user_id : user_id},
            success:function(data){
                $.ajax({
                    type : 'POST',
                    url : '/movies/load_movie_rating',
                    data : { movie_id : movie_id },
                    success: function(data){
                        $("#load_rating").html(data)
                    }
                })
            },
        });
         
    }); 

    $(".slide").live('mouseenter',function(){
          $(this).css({"background-color":"#666666","background-image":"","z-index":"1"});
          $(this).animate({"height":'250px',"width":'200px'},"fast");
              $(this).children(".slide_cont").slideDown(10);
    });
    $(".slide").live('mouseleave',function(){
                  $(this).children(".slide_cont").slideUp(10);
          $(this).css({"background-color":"","height":"","width":"","z-index":"0"});
                  $(this).animate({"border":"2px solid #DDDDDD","border-radius":"8px 8px 8px 8px","left":"10%","margin-top": "-7px","padding":"5px","position":"absolute","top":"10%","transition-duration":"0.3s"},1);
    });




    /*news_urls ui code */

    // album_selection

    $("#album_urls").click(function(){
        var id = 1
        $.ajax({
            type :'POST',
            url:'/newsurls/album_urls',
            data:{ id : id },
            success : function(){
                
            }

        });
    });
     $("button[id^='album_scrap_url_submit1-']").click(function(){
        var id = $(this).attr('id').split('-')[1]
        alert(id)
        if ($('#movie_select_dropdown-'+id).val() == "" && $('#artist_select_dropdown-'+id).val() == ""){
            alert("select any one in movie and artist");
        }else{
            if ($('#movie_select_dropdown-'+id).val() != "") {
                var movie_id = $('#movie_select_dropdown-'+id).val()
                var scrap_url = $("#album_scrap_url-"+id).text();
                
                var posting_type = "create-movie_"+movie_id+"-movie_selection"
                $.ajax({
                    type : 'GET',
                    url: '/posts/album_scrapping',
                    data : {id : id, scrap_url : scrap_url , posting_type : posting_type},
                    beforeSend:  function(){
                        $('#album_scrap_url_submit1-'+id).text("Adding");
                    },
                    failure: function(){
                        $('#wait_process').html('oops something went wrong... cannot scrap this.. kindly copy paste from site');
                    },
                    success : function(){
                        $('#album_scrap_url_submit1-'+id).text("success");
                        //window.location.href = "/";
                    }

                });
            }else{
                var artist_id = $('#artist_select_dropdown-'+id).val()
                var scrap_url = $("#album_scrap_url-"+id).text();
                var posting_type = "create-artist_"+artist_id+"-artist_selection"
                $.ajax({
                    type : 'GET',
                    url: '/posts/album_scrapping',
                    data : { id : id,scrap_url : scrap_url , posting_type : posting_type},
                    beforeSend:  function(){
                        $('#album_scrap_url_submit-'+id).text("Adding");
                    },
                    failure: function(){
                        $('#wait_process').html('oops something went wrong... cannot scrap this.. kindly copy paste from site');
                    },
                    success : function(){
                        $('#album_scrap_url_submit-'+id).text("success");
                        //window.location.href = "/";
                    }

                });
            }
        }    
       /* var scrap_url = $('#album_scrap_url').val();
        var posting_type = $("#posting_type").val();
        var mention_movie_id = $("input[name='mention_movie_id']").val();
        var mention_artist_id = $("input[name='mention_artist_id']").val();
        var date = $('#album_date').val();
        var scraptext = scrap_url.trim();*/    
        
    });

    //end

/* notification toggle script */

    $('.notify_user').toggle(function() {
        $('.notify_area').fadeIn();
        $('.birthday_popup').hide();
        $.ajax({
            type : 'GET',
            url : '/users/notifications',
            success: function(data){
               $('#notifylist').html(data);
            }
        });
        $('#notifylist').slimScroll({
                width: '450px',
                height: '250px',
                size: '7px',
                color: 'black',
                alwaysVisible: true,
                distance: '5px',
                start: 'top',
                railVisible: true,
                railColor: '#222',
                railOpacity: 0.3,
                wheelStep: 10,
                allowPageScroll: false,
                disableFadeOut: false
        });
        $('#ncount').hide();
    },function() {
        $('.notify_area').hide();
    });

//birthday dropdown
    $('.birthday_icon').toggle(function() {
        $('.notify_area').hide();
        $('.birthday_popup').fadeIn();
        $.ajax({
            url: '/artists/birthday',
            success: function(data) {
                $('#bdaylist').html(data);
            }
        });
    },function() {
        $('.birthday_popup').hide();
    });

    $('.common_inpt').live('keydown',function (e){
        var greeting = $(this).val();
        var user_id = $(this).next().val();
        var id = $(this).next().next().val();

        if(e.keyCode == 13){
            if (greeting.length == 0) {
            }
            else {
              $.post('/artists/'+id+'/bday_greeting',{ greeting : greeting,user_id : user_id });
             return false;
            }
        }
    }); 

});

/****end*********/     

/*****admin ability to edit posts*********/
$('#post_edit').click(function() {
    $.ajax({
        url: '/posts/edit_post_popup_code',
        success: function(data) {
            $(this).hide();
            $('#edit_post').css({'position':'absolute','top':'200px','left':'300px','z-index':'1','background-color':'#75A3FF','width':'650px'}).show();
            $("#edit_post").html(data);        
        }
    });
});

    $('form#submit_form').submit(function(){
        $('#post_edit').show();
        $('#edit_post').hide();
    });

    $('#edit_close').click(function(){
        $("#edit_post").css('display','none');
        $('#post_edit').show(); 
    });

    /***admin ability to edit posts***/
    $('#sub_edit_movie').children("#movie_select_dropdown").click(function() {
        $("input[name='edit_movie_id']").val($("#movie_select_dropdown").val()).back();
    });

    $('#sub_edit_artist').children("#artist_select_dropdown").click(function() {
        $("input[name='edit_artist_id']").val($("#artist_select_dropdown").val()).back();
    });

    $('#sub_edit_event').children("#event_select_dropdown").click(function() {
        $("input[name='edit_event_id']").val($("#event_select_dropdown").val()).back();
    });
    /***** end ***/
  /*******end************/
  /****Trending posts****/

    $('.trending').live('click',function(){
        var post_id=$(this).attr('postid')
        var self=this
        $.ajax({
            type: 'GET',
            url:   'posts/'+post_id+'/trending',
            success: function(data){
                $(self).text(data);
            },
            failure: function(data){
               alert('unexpected error occured try again.....');
            }
        });
    });

/***end trending**/

    
/***********artist page disc********/
$(document).ready(function(){

    //home page album images render

    $(".featurette1 a[id^='album_photo-']").click(function(){
        var id = $(this).attr('id').split("-")[1];
        alert(id);
    });

    var win_height = $(window).height();
    //alert(win_height);
    $('.artist_container').css('height',win_height-51+'px');
    $('.artist_desc_area').css('height',win_height-128+'px');
    
    
    $('.discus_area').css('height',win_height-150+'px');
    var win_width = $(window).width();
    var final_win_width = win_width-200;
    $('.discus_area').css('width',final_win_width-20+'px');

    $('.add_disc_btn').toggle(function(){
        $('.share_popup').fadeIn(200);
     /**   $('.add_new_desc').show(500);  *******/
    },
    function(){
        $('.share_popup').hide();
        $('.add_new_desc').hide(500);
    });

    $('#dis_slim').slimScroll({ 
          width: '330px',
          height: '400px',
          color: '#00E600',
          railVisible:true,
          railsColor: '#99FF99',
          railOpacity: 1
     });

    $('.disc_thread_link').slimScroll({ 
          width: '520px',
          height: '450px',
          color: '#00E600',
          railVisible:true,
          railsColor: '#99FF99',
          railOpacity: 1
     });
   
    $('.disc_thread_text').click(function(){
        var id=$(this).attr('id')
        $.ajax({
            type: 'get',
            url : '/discussions/'+id,
            success:function(data){
                $('.discus_area_right').html(data);
            },
            failure:function(data){
                alert('try again........');
            }

        });
    });

    $(".add_pho").click(function(){
        $('.disc_image').trigger('click');
    }); 

    $('.disc_image').change(function(){
        $('.image-preview').html("<p class='disc_head'>Uploading image </p><img src='/assets/select2-spinner.gif' >");
    });

    $('#disc_form').submit(function(){
        $('.image-preview').html("<p class='disc_head'>sending .. </p><img src='/assets/select2-spinner.gif'/>")
    });

});
/******end***/

/******-- jQuery carousel script--**********/
$(function() {
    if ($('.slider').length > 0) {
        $('.slider').carouFredSel({
            circular: true,
            infinite: true,
            auto: true,
            prev: '.prev',
            next: '.next',
            mousewheel: true,
            swipe: {
                onMouse: true,
                onTouch: true
            }
        });
    }
});
/*********jQuery carousel script**************/

    //header stuff
    /*$('.notify').toggle(function() {
        $('.notify_area').fadeIn(1000);
    },function() {
        $('.notify_area').hide();
    });*/
    
     //logut toggle script 
    $('.header_user_icon').toggle(function() {
        $('.logout_popup').show();
    },
    function() {
        $('.logout_popup').hide();
    });

    //cover image selection for album upload
    
    $("img[id^='thumb-selction-']").live('click', function(){
        var image_id = $(this).attr("id").split('-')[2];
        $('.thumb-selection').removeClass('selected color-change');
        $(this).addClass('selected');
        $(this).addClass('color-change');
        var arr = $("img.selected").map(function(){
                return $(this).attr("data-cover-image-id");
                }).get();
        //console.log(arr);
        //console.log(arr[0]);
        var image = $(this).attr('data-image-src')
        $('.image-preview').html("<p class='image-area' id='image_id-'" + arr[0] +" ><img src='" + image + "'</p>");
        $("input[name='cover_image_id']").val(arr[0]);
    });

$("a[id^='rmv-']").live('click', function(){
    var id = $(this).attr("id").split('-')[1];
    var movie_id = $(this).attr("id").split('-')[2];
    $.ajax({
        type : 'GET',
        url : '/movies/'+id+'/review_delete',
        data : { id : id },
        success : function(data){
            $.ajax({
                url : "/movies/" + movie_id +"/load_reviews",
                success : function(data){
                    $('.reviews_result').html(data).show();
                }
            })
        }
    });
});

 /* user like reviews in movie show page */      
$("a[id^=like_reviews-]").live('click', function(){
           
    user_id = $(this).attr('id').split('-')[1];
    review_id = $(this).attr('id').split('-')[2];
    $.ajax({
        type : 'POST',
        url : '/movies/reviews_like',
        data : { review_id : review_id, user_id : user_id, value : 1 },
        success : function(data){
            
        }
    })
});        

$("a[id^=like_review-]").live('click', function(){
    user_id = $(this).attr('id').split('-')[1];
    review_id = $(this).attr('id').split('-')[2];
    $(this).html("Lk");
    $.ajax({
        type : 'POST',
        url : '/movies/reviews_like',
        data : { review_id : review_id, user_id : user_id, value : 1 },
        success : function(data){
             
            
        }
    });
});

/* post coment like*/
$("a[id^=post_like-]").live('click',function(){
    $(this).html("liked");
    user_id = $(this).attr('id').split('-')[2];
    comment_id = $(this).attr('id').split('-')[1];
       $.ajax({
       type : 'POST',
       url : '/comments/comment_like',
       data : { comment_id : comment_id, user_id : user_id },
        success : function(){
            
        }
    });
});
/* post comment delete */
$("a[id^=post_delete-]").live('click',function(){
    comment_id = $(this).attr('id').split('-')[1];
    post_id = $(this).attr('id').split('-')[2];
    $('#post-description-' + post_id).html("<img src='http://www.traceinternational.org/images/loading4.gif' style ='height:50px;" +
                                    "width:50px;'/>");
    $.ajax({
       type : 'POST',
       url : '/comments/comment_delete',
       data : { comment_id : comment_id},
         success: function() {
            $.ajax({
                type : 'GET',
                url : "/posts/" + post_id +"/load_home_page_comments",
                success : function(data){
                    
                    $('#post_description-' + post_id).html(data);
                    reloadMasonry();
                }
            });
        }
    });
});

$("a[id^=dislike_review-]").live('click', function(){
        
        user_id = $(this).attr('id').split('-')[1];
        review_id = $(this).attr('id').split('-')[2];
        $(this).html("UL");
        $.ajax({
            type : 'POST',
            url : '/movies/reviews_like',
            data : { review_id : review_id, user_id : user_id, value : 0 },
            success : function(data){
                
            }
        });
    });


$("a[id^='reviews-']").click(function(){
    $( this ).css( "color", "red" );
    $(".newclass1").css("color","white");
    $(".newclass2").css("color","white");
    $(".newclass4").css("color","white");
    $(".reviews_show").show();
    $(".movie").hide();
    $(".filter").hide();      
});



/*create the reviews for movie */
/*review */

$(".post_btn").live('click', function(){
    var review;
    analysis = $('.small_textarea').val();
    movie_id = $('#movie_id').val();
    user_id = $('#current_id').val();
    $.ajax({
        type : 'POST',
        url : '/movies/movie_reviews',
        data : { movie_id : movie_id, analysis : analysis, user_id :user_id},
        success : function(data){
            $.ajax({
                type :'POST',
                url : '/movies/load_reviews',
                data : { movie_id : movie_id},
                success : function(data){
                    
                    $('.rivews_res').html(data).show();
                }
            })
                //$('.reviews_result').html(data);
        }
    });
    $(".small_textarea").val(" ");
 });

$(".cancel_btn").live('click', function(){
    $(".small_textarea").val(" ").show();
});

$('.widget_close_icon').click(function(){
    $('.widget_container').remove();
    reloadMasonry();
});


