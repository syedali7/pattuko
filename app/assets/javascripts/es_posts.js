function getMouseoverHtml(postObj){
    var html = '<div class="movie_share">' + 
        '<a href="javascript:void(0);" class="movie_fb float_L" data-id="'+ postObj.id+'"></a>' + 
        '<div class="movie_circle float_R hover-section" id="fan-section-' + postObj.id + '" data-id="'+ postObj.id+'">' +
            '<div class="movie_circle_inner float_L" id="fan-section-' + postObj.id +'">' + 
                '<div class="movie_circle_inner_lft float_L" id="hover-content-' + postObj.id + '"></div>' +
                '<div class="movie_circle_inner_rgt float_R">' + 
                    '<ul>' +
                        '<li><a href="javascript:void(0)" id="home-page-clap-'+ postObj.id +'">Clap</a></li>' +
                        '<li><a>Share</a></li>' +
                        '<li><a href="javascript:void(0)">Link/Embed</a></li>' + 
                        '<li><a data-remote="true" href="/posts/' + postObj.id +'/block">Report</a></li>' ;
                        if (ADMIN_SESSION == true){
                            html = html + '<li><a href="javascript:void(0)">Delete</a></li>' + 
                                    '<li><a href="javascript:void(0)"" class="trending" postid="' + postObj.id + '">trending</a></li>' +
                                    '<li><a href="javascript:void(0)" id="trusted" data_id="'+ postObj.id +'">trusted</a></li>';
                        }
                    html = html + '</ul>' +
                '</div>' +
            '</div>' +
        '</div>' +
    '</div> ';
    return html;
}

function getAlbumHtml(postObj){
    var html = '<div class="container marketing">' +
                    '<div class="featurette1">' +
                        '<ul class="thumbnails" id="album_render-'+ postObj.id + '">' +
                            '<li class="span4 isotope-item" style="position: absolute; left: 0px; top: 0px; -webkit-transform: translate3d(0px, 0px, 0px);">' +
                                '<a href="'+ postObj.image_url_thumb +'" id="album_photo-'+ postObj.id + '">' +
                                    '<img src="'+ postObj.image_url_thumb +'">' +
                                '</a>' +
                            '</li>' +
                        '</ul>' +
                    '</div>' +
                '</div>';
    return html;
}


function getPostsHtml(postObj) {
    var mousehtml = getMouseoverHtml(postObj);
    var album_html = getAlbumHtml(postObj);
    var html = '<div class="box col2">' +
        '<div class="hoverDiv" data-post-id="' + postObj.id + '">' + mousehtml;

            html = html + '<p class="image-area" id="post-' + postObj.id + '" style="height:' + postObj.image_thumb_height + 'px;">' ;

            if(postObj.postable_type == "Album") {
                html = html + album_html;
                html = html + '<a href="' + postObj.es_show_path + '"><span class="pt_album_icon"></span></a>';
            }
            else {
                html = html + '<a href="javascript:void(0);" style="height:' + postObj.image_thumb_height +'px;" data-url="'+ postObj.es_show_path +'">' +
                    '<img class="lazy" src="http://static.icontainers.com/images/loading.gif" data-original="' + postObj.image_url_thumb + '" />' +
                '</a>';
            }

            if(postObj.postable_type == "Video") {
                html = html + '<a href="' + postObj.es_show_path + '"><span class="pt_video_icon"></span></a>'
            }
            html = html + '</p>';
            
            html = html +  '<span class="movie-comments">' + postObj.title + '</span>';
            if (postObj.trusted == true) {
                html = html + '<img class="ribben" src="/assets/ribben.png" width="30" height="37">';    
            }
            if ((postObj.postable_type == "Image") && (ADMIN_SESSION == true)){
                html = html + '<input type="checkbox" class="image-select" name="vehicle" value="'+ postObj.image_id +'">Create Album<br>';
                html = html + '<a href="javascript:void(0);" class="create-album">Submit</a>';    
            }
        html = html + '</div>' +
    '</div>';

    return html;
}

function getRelatedPostsHtml(relatedPostObj) {
    return getPostsHtml(relatedPostObj.related_post);
}

function getMoviesHtml(movieObj){
    var html = '<li class="movie-box box">' +
        '<a class="overlay animation_class" href="/movies/'+ movieObj.slug + '"></a>' +
        '<a href="/movies/' + movieObj.slug +'">' +
            '<img width="240" height="320" alt="' + movieObj.name + '" class="lazy" data-original="' + movieObj.image_url_medium + '" style="display: block;">' +
        '</a>' + 
        '<div class="movie_desc animation_class">' + 
            '<p class="movie">' + movieObj.name + '</p>' +
            '<span>' +
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

function getArtistsHtml(artistObj) {
    var html = '<li class="movie-box box">' +
        '<a class="overlay animation_class" href="/artists/' + artistObj.slug  + '"></a>' +
        '<a href="/artists/' + artistObj.slug + '">' +
            '<img alt="Lazy img load" class="lazy" data-original="' + artistObj.image_url_medium + '" src="" style="display: block;">' + 
        '</a>' +
        '<div class="movie_desc animation_class">' +
            '<p class="movie">' + artistObj.name + '</p>' +
            '<span>' +
                '<a href="javascript:void(0)" class="cmn_link">claps 10</a>' +
                '<a href="javascript:void(0)" class="cmn_link">Views 3</a>' +
                '<a href="javascript:void(0)" class="cmn_link">Fans 0</a>' +
            '</span>' +
            '<input type="button" class="cmn_btn float_R" id="index-artist-fan" data-id="9920-52" value="I\'m Fan">';

    if (ADMIN_SESSION == true){
        html = html + '<form accept-charset="UTF-8" action="/artists/' + artistObj.id + '/upload" enctype="multipart/form-data" method="post">' +
            '<div style="margin:0;padding:0;display:inline">' +
                '<input name="utf8" type="hidden" value="✓"><input name="authenticity_token" type="hidden" value="y/hCGHtY6XDYV/1lapJ/7eOwBtJJsy/Zu3+s9wXk8IA=">' +
            '</div>' +
            '<input id="artist_image" name="artist_image" type="file">' +
            '<input name="commit" type="submit" value="submit">' +
        '</form>';
    }

    html = html + '</div>' + '</li>';

    return html;
}

function displayMovieFacets(movieFacets){
    var html = "";
    for (var i = 0; i < movieFacets.length; i++) {
        if (movieFacets[i].term != ''){
             html = html + '<li data-no-turbolink ><a href="/movie/'+ movieFacets[i].term+'">'+ movieFacets[i].term +'('+ movieFacets[i].count +')</a> </li>';
        }
    };
    $('ul','.movie_facets').html(html);
}

function displayArtistFacets(artistFacets){
    var html = "";
    for (var i = 0; i < artistFacets.length; i++) {
        if (artistFacets[i].term != ''){
            html = html + '<li data-no-turbolink><a href="/artist/'+ artistFacets[i].term+'">'+ artistFacets[i].term +'('+ artistFacets[i].count +')</a> </li>';
        }
        
    };
    $('ul','.artist_facets').html(html);
}
 
function initialPageLoad(entityName) {
    var containerName = entityName + "_container";

    var $container = $("#" + containerName);
    reloadMasonry($container);

    // if the height is fixed then make it slim scroll
    if ($container.attr('data-fixed-height') == "true") {
        $container.slimScroll({
            height: $(window).height() - 60,
            color: '#ffffff',
            railColor: '#ffffff'
        });
    }

    var start_point = 0;
    var query_data = $.parseJSON($container.attr('data-es-query'));

    var request_data = {"query"  : query_data , "from": 0,"size":20 };
    if ($container.attr('data-es-sort-query') != undefined) {
        request_data.sort = $.parseJSON($container.attr('data-es-sort-query'));
    } else {
        request_data.sort = [{"id" : "desc" }];
    }
    var str = JSON.stringify(request_data);

    // first send the request to find the total number of pages
    var capitalEntityName = entityName.charAt(0).toUpperCase() + entityName.slice(1);
    var searchUrl = window['get' + capitalEntityName + 'SearchUrl']();

    $.ajax({
        url: searchUrl + "?source=" + str,
        success: function(data) {
            if ($.type(data) == "string") data = JSON.parse(data);
            var totalPages = parseInt(data.hits.total / 20) + 2;

            var pagelessContainer = window;
            if ($container.attr('container') == "true") {
                pagelessContainer = $container;
            }

            $container.pageless({
                //url : "http://localhost:9200/dev_posts/post/_search?source=" + str,
                url : searchUrl + "?source=" + str,
                totalPages : totalPages,
                distance : 200,
                container: pagelessContainer,
                loaderImage: 'http://d2tgu4jwper4r3.cloudfront.net/loader_with_bg.gif',
                scrape : function(data) {   
                    // update the from values - start_point
                    start_point = parseInt(start_point) + 20;
                    request_data.from = start_point;
                    str = JSON.stringify(request_data);
                    //this.url = "http://www.pattuko.com:9200/posts/post/_search?source=" + str;
                    this.url = searchUrl + "?source=" + str;
                    if (start_point > 50) {
                        this.distance = 2000;
                    }

                    var tmp = JSON.parse(data).hits.hits;
                    var html = "";
                    for(var i = 0; i < tmp.length; i++) {
                        html = html + window['get' + capitalEntityName + 'Html'](tmp[i]._source);
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
                    $container.masonry( 'appended', $newElems, true );

                    $("img.lazy").lazyload({container: pagelessContainer}).removeClass("lazy");
                    //addToolTips();

                    ilghtboxForAlbums();

                    // TODO bad way of doing it but no other way
                    $(window).resize();
                }
            });
            $("img.lazy").lazyload().removeClass("lazy");

            $(window).resize();
        } 
    });
}

$(document).on("page:before-change", function() {
    $.pagelessReset();
});

$(function() {
    if ($("#movies_container").length > 0) {
        initialPageLoad('movies');    
    }

    if ($("#posts_container").length > 0) {
        initialPageLoad('posts');    
    }

    if ($("#artists_container").length > 0) {
        initialPageLoad('artists');    
    }

    if ($("#relatedPosts_container").length > 0) {
        initialPageLoad('relatedPosts');    
    }

});
