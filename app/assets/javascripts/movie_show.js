/*function hashChanged() {

    var query = $.bbq.getState("q");

    if (query != null) {
        var val = query.substring(query.lastIndexOf('-') + 1);
        $('.show_popup').show();
        $(".reviews_show").hide();
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
    }

}

$(window).hashchange(function(e) {
	e.preventDefault();
	hashChanged();
});

$(document).ready(function() {


    hashChanged();

    $("a[id^='activities-']").click(function(){

        $.bbq.pushState({"q" : "activities"});

    });
});*/