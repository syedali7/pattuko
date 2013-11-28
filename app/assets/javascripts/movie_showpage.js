$(document).ready(function(e) {
	
	/* notification toggle script */
    $('.notify_user').toggle(function() {
        $('.notify_area').fadeIn(1000);
    },function() {
        $('.notify_area').hide();
    });
	
	/* logut toggle script */
	 $('.header_user_icon').toggle(function() {
        $('.logout_popup').fadeIn(1000);
    },function() {
        $('.logout_popup').hide();
    });
	
	
	/* logut toggle script */
	 $('.birthday_icon').toggle(function() {
        $('.birthday_popup').fadeIn(1000);
    },function() {
        $('.birthday_popup').hide();
    });
	
	var win_height = $(window).height();
	$('.artist_container').css('height',win_height-51+'px');

	/* new movie page script */
	$('.new_mov_cont').css('height',win_height-115+'px');
	$('.mov_left_section').css('height',win_height-115+'px');
	$('.mov_right_section .artist_item').css('height',win_height-115+'px');
	$(".mov_left_section").niceScroll({touchbehavior:false,cursorcolor:"#000",cursoropacitymax:0.5,cursorwidth:8});
	/* new movie page script */
	
	
	$('.add_disc_btn').toggle(function(){
	$('.add_new_desc').show(500);
	},
	function(){
	$('.add_new_desc').hide(500);
	});
	
	$("input[id^='movie_fan']").click(function(){

        var movie_id = $("#movie_id").val();
        var user_id = $("#user_id").val();
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
                    //var f = add($("#fan_count").val()+1);
                    //$("#fans").replaceWith(f);
                    element.remove();
                },
                failure: function(){
                    element.val("I'm Fan");
                }
            });  
        }
    });

    $("a[id^='activities']").live('click', function(){
        $(".reviews_show").hide();
        $(this).css( "color", "red" );
        $(".newclass2").css("color","white");
        $(".newclass3").css("color","white");
        $(".newclass4").css("color","white");
        var movie_id = $(this).attr('id').split('-')[1];
        //alert(movie_id);
        $.ajax({
            type : 'GET',
            url : '/movies/' + movie_id+ '/activities',
            data : { movie_id : movie_id },
            success: function(data) {
                $("#main").html(data).show();
                setTimeout(function() {
                    reloadMasonry();
                }, 500);
            }
        });
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
            $("#main").html(data).show();
                setTimeout(function() {
                    reloadMasonry();    
                }, 500);
            
             },
        });
    });
});