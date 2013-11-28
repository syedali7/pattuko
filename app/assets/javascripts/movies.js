function getMovieHtml(movieObj){
    var html = '<li class="movie-box box">' +
        '<a class="overlay animation_class" href="/movies/989"></a>
        <a href="/movies/' + movieObj.slug +'">
        	<img alt="' + movieObj.name + '" class="lazy" data-original="http://d2tgu4jwper4r3.cloudfront.net/uploads/movie/movie_image/989/medium_989-Priyudu-Varun-Sandesh.jpg" style="display: block;">' +
    	'</a>' + 
        '<div class="movie_desc animation_class">' + 
            '<p class="movie">' + movieObj.name + '</p>'
            '<span>'
                '<a href="javascript:void(0)" class="cmn_link">claps 10</a>' +
                '<a href="javascript:void(0)" class="cmn_link">Views ' + movieObj.total_views + ' </a>' +
                '<a href="javascript:void(0)" class="cmn_link">Fans ' + movieObj.fans.length + '</a>' +
            '</span>' + 
            '<input type="button" class="cmn_btn float_R" id="index-movie-fan" data-id="' + movieObj.id + '-1" value="I\'m Fan">';

    if (ADMIN_SESSION == true){
        html = html + '<form accept-charset="UTF-8" action="/movies/' + movieObj.id + '/upload" data-remote="true" enctype="multipart/form-data" method="post">' + 
            '<input id="movie_image" name="movie_image" type="file">' +
                '<input name="commit" type="submit" value="submit">' +
		'</form>';
	}
	html = html + '</div>' +
    '</li>';

    return html;
}

function initialPageLoad() {
    reloadMasonry($("#movies_container"));

    // if the height is fixed then make it slim scroll
    if ($("#movies_container").attr('data-fixed-height') == "true") {
        $("#movies_container").slimScroll({
            height: $(window).height() - 60,
            color: '#ffffff',
            railColor: '#ffffff'
        });
    }

    var start_point = 0;
    var query_data = $.parseJSON($('#movies_container').attr('data-es-query'));

    var request_data = {"query"  : query_data , "from": 0,"size":20,"sort": [{"id" : "desc" }] };
    var str = JSON.stringify(request_data);

    // first send the request to find the total number of pages
    $.ajax({
        url: getPostSearchUrl() + "?source=" + str,
        success: function(data) {
            var totalPages = parseInt(data.hits.total / 20) + 2;

            var container = window;
            if ($('#movies_container').attr('container') == "true") {
                container = $('#movies_container');
            }

            $('#movies_container').pageless({
                //url : "http://localhost:9200/dev_posts/post/_search?source=" + str,
                url : getPostSearchUrl() + "?source=" + str,
                totalPages : totalPages,
                distance : 200,
                container: container,
                loaderImage: 'http://d2tgu4jwper4r3.cloudfront.net/loader_with_bg.gif',
                scrape : function(data) {   
                    // update the from values - start_point
                    start_point = parseInt(start_point) + 20;
                    request_data.from = start_point;
                    str = JSON.stringify(request_data);
                    //this.url = "http://www.pattuko.com:9200/posts/post/_search?source=" + str;
                    this.url = getPostSearchUrl() + "?source=" + str;
                    if (start_point > 50) {
                        this.distance = 2000;
                    }

                    var tmp = JSON.parse(data).hits.hits;
                    var html = "";
                    for(var i = 0; i < tmp.length; i++) {
                        html = html + getPostHtml(tmp[i]._source);
                    }
                    return html;
                },
                complete: function(data) {
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
                    $('#movies_container').masonry( 'appended', $newElems, true );

                    $("img.lazy").lazyload({container: container}).removeClass("lazy");
                    //addToolTips();
                }
            });
            $("img.lazy").lazyload().removeClass("lazy");
        } 
    });
}

$(function() {
    initialPageLoad();    
});
