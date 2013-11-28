function post_show(data_url) {
    $.ajax({
        url: data_url,
        success: function(data) {
            $(".show_post_popup").html(data).show();

            // finally call the initial page load for the related Posts
            //initialPageLoad("relatedPosts");

            // related posts masonry apply
            /*reloadMasonry($("#related_posts_container"));

            $("img.lazy").lazyload({
                "container" : $("#related_posts_container"),
                "threshold": 200
            });*/

            // finally add the next and prev clicks
            $("a", ".show_popup_pagination").click(function() {
                post_show($(this).attr('data-post-id'));
            });

            // finally call the initial page load for the 

            // TODO pageless needs to be applied to all related posts
            /*$('#related_posts_container').pageless({
                url : $('#related_posts_container').attr('data-url'),
                totalPages : 100,
                distance : 200,
                loaderImage: '/assets/loader_with_bg.gif',
                container: $('section.show_popup'),
                complete: function(data) {
                    //console.log(data);
                    // get all the box elements whose style is empty b10d fix but for now
                    var newElements = [];
                    var boxElements = $(".box");
                    for(var i = 0; i < boxElements.length; i++) {
                        if ($(boxElements[i]).attr("style") == undefined) {
                            newElements[newElements.length] = boxElements[i];
                        }
                    }

                    var $newElems = $( newElements );//.css({ opacity: 0 });
                    //$newElems.animate({ opacity: 1 });
                    $('#related_posts_container').masonry( 'appended', $newElems, true );
                }
            }); */
        },
        failure: function() {
            alert("error in loading post");
        }
    });

    // finally add the hash for the post url
    $.bbq.pushState({"p" : data_url});

    //history.pushState({}, '', data_url);
    return false;
}

$(document).ready(function() {
    $("a", 'p.image-area').live('click', function(){
        // check if the a href attribute is not the url
        var href = $(this).attr('href');
        if (href.indexOf("javascript:void") != -1) {
            var data_url = $(this).attr('data-url');
            post_show(data_url);
            $("#overlay").show();
            // set the overflow-y as hidden to the html
            $("html").css('overflow-y', "hidden");
            $(".show_post_popup").css("overflow-y", "scroll");  

            $(window).resize();
        }
    });

    $(".show_popup_close").live('click', function(){
        $(".show_post_popup").html('');
        $(".show_post_popup").css("overflow-y", "hidden");

        if ($("#posts_container").length > 0 && $("#posts_container").attr('container') != undefined) {
            $("html").css('overflow-y', "hidden");
        } else {
            $("html").css('overflow-y', "scroll");    
        }
        
        $(".show_post_popup").hide();

        // remove the hash thats all
        $.bbq.pushState({"p" : ""});

        //history.pushState({}, '', '/');
        $("#overlay").hide();

        // finally reset the pagination on the related_posts
        $(window).resize();
    });
});