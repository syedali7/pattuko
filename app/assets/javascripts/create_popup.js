// #create
// #create-artist
// #create-artist_12_nitin-selection
// #create-artist-12-nitin-selection-news

// hide all the panels but show only one
//create-panel
//movie-panel
//artist-panel
//movie-selection-panel
//news-panel

function movieFormatResult(movie) {
    var markup = "<table class='movie-result'><tbody><tr>";
    markup += "<td class='movie-image' style= height: 23px;><img style= width:35px; src='" + movie.movie_image + "'/></td>"; 
    markup += "<td class='movie-info'><div class='movie-title'>" + movie.name + "</div>";
    markup += "<div class='movie-synopsis'>" + movie.year + "</div>";
    markup += "</td></tr></tbody></table>"
    return markup;
}

function movieFormatSelection(movie) {
    return movie.name;
}

function artistFormatResult(artist) {
    var markup = "<table class='movie-result'><tr>";
    markup += "<td class='movie-image' style= height: 23px;><img style= width:35px; src='" + artist.artist_profile_image.url + "'/></td>"; 
    markup += "<td class='movie-info'><div class='movie-title' id='"+ artist.name +"'>" + artist.name + "</div>";
    markup += "</td></tr></table>"
    return markup;
}

function artistFormatSelection(artist) {
    return artist.name;
}

function eventFormatResult(event) {
    var markup = "<table class='movie-result'><tr>";
    markup += "<td class='movie-info'><div class='movie-title'>" + event.name + "</div>";
    markup += "</td></tr></table>"
    return markup;
}

function eventFormatSelection(evnet) {
    return event.name;
}

function hashChanged() {
	$("div[id$='-panel']", "#create").hide();

    if ($.bbq == undefined) {
        return;
    }

	var query = $.bbq.getState("q");

    //breadcumb change of movie or artist name when refresh browser

    var mov = $("#movie-name-bc").html();
    var art = $("#artist-name-bc").html();

    if (query != null) {
        if (art == "Artist Name") {
            if (query.split("_")[1] != undefined) {
                var sub_query = query.split("_");
                var type = query.split("_")[0].split("-")[1];
                if (type == "artist") {
                    var val = query.split("_")[1].split("-")[0];
                    $.ajax({
                        type : 'GET',
                        url: '/artists/' + val  + '/get_artist_name',
                        data : { val : val }
                    }); 
                }
            }
        }

        if (mov == "Movie Name") {
            if (query.split("_")[1] != undefined) {
                var sub_query = query.split("_");
                var type = query.split("_")[0].split("-")[1];
                if (type == "movie") {
                    var val = query.split("_")[1].split("-")[0];
                    $.ajax({
                        type : 'GET',
                        url: '/movies/' + val  + '/get_movie_name',
                        data : { val : val }
                    }); 
                }
            }
        }

        $.ajax({
            type : 'GET',
            url: '/movies/' + query  + '/navigation',
            data : { query : query },
            success: function(data) {
                if (query.split("_")[2] != undefined) {
                    var type = query.split("_")[2].split("-")[1];
                    $('#navigation_'+ type).html(data);
                }
                
            }
        });

        console.log(query);
    }

    // if artist or movie id present in the query we should add to the hidden element
    //var tmp = query.split("-");
    /*if (tmp[1] != null) {
        tmp = tmp[1].split("_");
        $("input[name='type_id']").val(query);
        if (tmp[0] == "movie") {
            $("input[name='movie_id']").val(tmp[1]);
        } else if (tmp[0] == "artist") {
            $("input[name='artist_id']").val(tmp[1]);
        }
    }*/
    $("input[name='posting_type']").val(query);

	if (query != null) {
		var val = query.substring(query.lastIndexOf('-') + 1);
		$("#create").show();
		$("div[id='" + val + "-panel']").show();
	} else {
		$("#create").hide();
	}
}

function close_popup() {
    // remove the q param from the hash
    $.bbq.removeState("q");

    // reset the select2 values
    $("#movie_select_dropdown").select2('data', null);
    $("#artist_select_dropdown").select2('data', null);
    $("#event_select_dropdown").select2('data', null);

    $('#container').masonry({
        itemSelector: '.box',
        columnWidth: 50,
        isFitWidth: true
    });
    $(".post-movie-mention").hide();
    $(".post-artist-mention").hide();
}

function albumupload(){
    var arr = new Array();
    var title = $("#validate_album").find('#title').val();
    var alb = $("#validate_album").find('#album_name').val();
    var posting_type = $("#posting_type").val();
    var mention_movie_id = $("input[name='mention_movie_id']").val();
    var mention_artist_id = $("input[name='mention_artist_id']").val();
    var user_id = parseInt($('.user_id').html());
    var url = '/posts/album_create?';
    var imageIds = $("input[name='image_id']").val();
    var coverImageId = $("input[name='cover_image_id']").val();
    var imgids = [];
    imgids = imageIds.split("-");
    $.each(imgids,function(index,value){
        arr.push(value);
    });
    $.each(arr, function(index, value){
        url = url + 'image_ids[]=' + value + '&';
    });


    url = url + 'title=' + title + '&album_name=' + alb
        + '&posting_type=' + posting_type + '&post_fb=' + post_fb
        + '&user_id=' + user_id + '&cover_image_id=' + coverImageId
        + '&mention_movie_id=' + mention_movie_id + '&mention_artist_id=' + mention_artist_id
    window.location.href = url;
}

function applyEventsForPopupElements() {

    $("a", "ul.choice").click(function() {
        $.bbq.pushState({"q" : $(this).attr('data-value')});
        $(".post-movie-mention").hide();
        $(".post-artist-mention").hide();
    });
    $("a", "ul.choice_small").click(function() {
        $.bbq.pushState({"q" : $.bbq.getState("q") + "-" + $(this).attr('data-value')});

        var query = $.bbq.getState("q");
        $.ajax({
            type : 'GET',
            url: '/movies/' + query  + '/navigation',
            data : { query : query },
            success: function(data) {
                $('#navigation').html(data);
            }
        });         
        $("input[name='mention_artist_id']").val($('#mention_artist_select_dropdown').val() + "," + $('#mention_artist_select_dropdown_dup').val());
        $("input[name='mention_movie_id']").val($('#mention_movie_select_dropdown').val() + "," + $('#mention_movie_select_dropdown_dup').val());
        $(".post-movie-mention").hide();
        $(".post-artist-mention").hide();


    });

    $(".bc_artist", "ul.choice_bc_artist").live("click", function() {
        $.bbq.pushState({"q" : $(this).attr('data-value')});
        return false;
    });

    $(".bc_movie", "ul.choice_bc_movie").live("click",function() {
        $.bbq.pushState({"q" : $(this).attr('data-value')});
        return false;
    });

    $('.home_btn').live("click",function(){
       $.bbq.pushState({"q" : "create"}); 
       return false;
    });
    
    $("#mention_movie_select_dropdown").select2({
        multiple:true,
        placeholder: "Search for a Movie",
        minimumInputLength: 1,
        id: function(data){ return data.id; },
        ajax: {
            url: "/movies/2/query.json",
            dataType: 'json',
            data: function (term, page) {
                return {
                    q: term,
                    page_limit: 10
                };
            },
            results: function (data, page) {
                return {results: data.movies, more: (data.movies && data.movies.length == 10 ? true: false)};
            }

        },
        formatResult: movieFormatResult,
        formatSelection: movieFormatSelection,
        dropdownCssClass: "bigdrop",
        escapeMarkup: function (m) { return m; }
    });

    $("#mention_movie_select_dropdown_dup").select2({
        multiple:true,
        placeholder: "Search for a Movie",
        minimumInputLength: 1,
        id: function(data){ return data.id; },
        ajax: {
            url: "/movies/2/query.json",
            dataType: 'json',
            data: function (term, page) {
                return {
                    q: term,
                    page_limit: 10
                };
            },
            results: function (data, page) {
                return {results: data.movies, more: (data.movies && data.movies.length == 10 ? true: false)};
            }

        },
        formatResult: movieFormatResult,
        formatSelection: movieFormatSelection,
        dropdownCssClass: "bigdrop",
        escapeMarkup: function (m) { return m; }
    });

    $("#movie_select_dropdown").select2({
        placeholder: "Search for a Movie",
        minimumInputLength: 1,
        id: function(data){ return data.id; },
        ajax: {
            //url: "/movies/2/query.json",
            dataType: 'json',
            dataUrl: function(term, page) {
                var request_data = { "query": { "bool": { "must": [{ "query_string": { "query": "name:*" + term + "*"}}] }} };
                return getMoviesSearchUrl() + "?source=" + JSON.stringify(request_data);
            },
            data: function (term, page) {
                /*return {
                    q: term,
                    page_limit: 10
                };*/
                return "";
            },
            results: function (data, page) {
                var results = [];
                for (var i = 0; i < data.hits.hits.length; i++) {
                    var obj = data.hits.hits[i]._source;
                    results[i] = {"id" : obj.id, "name" : obj.name, "movie_image" : obj.movie_image, "year" : obj.year};
                }
                return {results: results,  more: false};
            }

        },
        formatResult: movieFormatResult,
        formatSelection: movieFormatSelection,
        dropdownCssClass: "bigdrop",
        escapeMarkup: function (m) { return m; }
    });

    
    $("#artist_select_dropdown").select2({
        placeholder: "Search for a Artist",
        minimumInputLength: 1,
        id: function(data) {
            return data.id;
        },
        ajax: {
            //url: "http://localhost:9200/dev_artists/artist/_search",
            dataType: 'json',
            dataUrl: function(term, page) {
                var request_data = { "query": { "bool": { "must": [{ "query_string": { "query": "name:*" + term + "*"}}] }} };
                return getArtistsSearchUrl() + "?source=" + JSON.stringify(request_data);
            },
            data: function (term, page) {
                return "";//{source : {"query"  : { "bool" : { "must" : [{"wildcard" :{"name" : term } }]} } , "from": 0,"size":20,"sort": [{"id" : "desc" }] }};
            },
            results: function (data, page) {
                var results = [];
                for (var i = 0; i < data.hits.hits.length; i++) {
                    var obj = data.hits.hits[i]._source;
                    results[i] = {"id" : obj.id, "name" : obj.name, "artist_profile_image" : obj.artist_profile_image};
                }
                return {results: results,  more: false};
            },
            initSelection: function(element, callback) {
                var id=$(element).val();
                if (id!=="") {
                    $.ajax("/artists/"+id+".json", {
                        data: {
                            id: (element.val())
                        },
                        dataType: "json"
                    }).done(function(data) { callback(data); });
                }
            }
        },
        formatResult: artistFormatResult,
        formatSelection: artistFormatSelection,
        dropdownCssClass: "bigdrop",
        escapeMarkup: function (m) {
            return m;
        }
    });

    $("#mention_artist_select_dropdown").select2({
        multiple:true,
        placeholder: "Search for a Artist",
        minimumInputLength: 1,
        id: function(data) {
            return data.id;
        },
        ajax: {
            url: "/artists/2/query.json",
            dataType: 'json',
            data: function (term, page) {
                return {
                    q: term,
                    page_limit: 10
                };
            },
            results: function (data, page) {

                return {results: data.artists,  more: (data.movies && data.artists.length == 10 ? true: false)};
            },
            initSelection: function(element, callback) {
                var id=$(element).val();
                if (id!=="") {
                    $.ajax("/artists/"+id+".json", {
                        data: {
                            id: (element.val())
                        },
                        dataType: "json"
                    }).done(function(data) { callback(data); });
                }
            }
        },
        formatResult: artistFormatResult,
        formatSelection: artistFormatSelection,
        dropdownCssClass: "bigdrop",
        escapeMarkup: function (m) {
            return m;
        }
    });

    $("#mention_artist_select_dropdown_dup").select2({
        multiple:true,
        placeholder: "Search for a Artist",
        minimumInputLength: 1,
        id: function(data) {
            return data.id;
        },
        ajax: {
            url: "/artists/2/query.json",
            dataType: 'json',
            data: function (term, page) {
                return {
                    q: term,
                    page_limit: 10
                };
            },
            results: function (data, page) {

                return {results: data.artists,  more: (data.movies && data.artists.length == 10 ? true: false)};
            },
            initSelection: function(element, callback) {
                var id=$(element).val();
                if (id!=="") {
                    $.ajax("/artists/"+id+".json", {
                        data: {
                            id: (element.val())
                        },
                        dataType: "json"
                    }).done(function(data) { callback(data); });
                }
            }
        },
        formatResult: artistFormatResult,
        formatSelection: artistFormatSelection,
        dropdownCssClass: "bigdrop",
        escapeMarkup: function (m) {
            return m;
        }
    });

    $("#event_select_dropdown").select2({
        placeholder: "Search for a Event",
        minimumInputLength: 1,
        id: function(data) {
            return data.id;
        },
        ajax: {
            url: "/posts/2/event_query.json",
            dataType: 'json',
            data: function (term, page) {
                return {
                    q: term,
                    page_limit: 10
                };
            },
            results: function (data, page) {

                return {results: data.events,  more: (data.events && data.events.length == 10 ? true: false)};
            },
            /*initSelection: function(element, callback) {
                var id=$(element).val();
                if (id!=="") {
                    $.ajax("/posts/"+id+".json", {
                        data: {
                            id: (element.val())
                        },
                        dataType: "json"
                    }).done(function(data) { callback(data); });
                }
            }*/
        },
        formatResult: eventFormatResult,
        formatSelection: eventFormatSelection,
        dropdownCssClass: "bigdrop",
        escapeMarkup: function (m) {
            return m;
        }
    });


    $('input[type="submit"]','#validate_image').click(function(){
        var img = $('img[id^="image_id-"]').length;
        if (img == 0){
            alert('image cannot be null');
            return false;
        }
        $("#validate_image").validate({
            rules:{
                "title":{ required:true},
                "content":{required:true}
            }
        });
    });

    $('input[type="submit"]','#validate_image_post').click(function(){
        var img = $('img[id^="image_id-"]').length;
        if (img == 0){
            alert('upload the image');
            return false;
        }
        $("#validate_image_post").validate({
            rules:{
                "title":{ required:true}
            }
        });
    });

    $('#validate_album').submit(function(){ 
        var img = $('img[id^="image_id-"]').length;
        /*if (img == 0){
            alert('upload images');
            return false;
        }*/
        $("#validate_album").validate({
            rules:{
                "title":{ required:true},
                "album_name":{required:true}
            }
        });
        
        var title = $("#validate_album").find('#title').val();
        var album_name = $("#validate_album").find('#album_name').val();
        if ( (title != undefined && album_name != undefined) && (title != '' && album_name != '')) {
            albumupload();
        }
    });

    $("#validate_video").validate({
        rules:{
            "title":{ required:true},
            "youtube_url":{required:true}
        }
    });

    $('#news_image_upload').fileupload();

    $('#test_news_image_upload').fileupload();

    $('#album_image_upload').fileupload();

    $('#image_upload').fileupload();

    $("#new-artist-btn").click(function(){

        var name = $("#artist-name").val();

        if (name.length != 0) {
            $(this).html("adding");
            $.ajax({
                type : 'POST',
                url: '/artists/user_artist_create',
                data : { name : name },
                beforeSend:  function(){
                    $(this).val("Adding");
                },
                success: function() {
                    
                }
            });
            
        }
        else {
            alert("enter the artist");
        }

    });

    $("#new-event-btn").click(function(){

        var name = $("#event-name").val();

        if (name.length != 0) {
            $.ajax({
                type : 'POST',
                url: '/posts/user_event_create',
                data : { name : name },
                beforeSend:  function(){
                    $(this).val("Adding");
                },
                success: function() {
                    
                }
            });
            
        }
        else {
            alert("enter the event name");
        }

    });

    $('#scrap_url_submit').click(function(){
        
        var scrap_url = $('#scrap_url').val();
        var image_url = $('#image_url').val();
        var posting_type = $("#posting_type").val();
        var mention_movie_id = $("input[name='mention_movie_id']").val();
        var mention_artist_id = $("input[name='mention_artist_id']").val();
        var scraptext = scrap_url.trim();
        var imagetext = image_url.trim();
        if (scraptext == "") {
            alert("please enter the url");
        }
        else{
            $('#wait_process').show();
            $.ajax({
                type : 'GET',
                url: '/posts/news_scrapping',
                data : { scrap_url : scrap_url , image_url : image_url, posting_type : posting_type, mention_movie_id : mention_movie_id, mention_artist_id : mention_artist_id },
                beforeSend:  function(){
                    $(this).html("Wait");
                },
                failure: function(){
                    $('#wait_process').html('oops something went wrong... cannot scrap this.. kindly copy paste from site');
                },
                success : function(){
                    window.location.href = "/";
                }

            });
        }
        
    });

    $('#album_scrap_url_submit').click(function(){
        
        var scrap_url = $('#album_scrap_url').val();
        var posting_type = $("#posting_type").val();
        var mention_movie_id = $("input[name='mention_movie_id']").val();
        var mention_artist_id = $("input[name='mention_artist_id']").val();
        var date = $('#album_date').val();
        var scraptext = scrap_url.trim();
        if (scraptext == "") {
            alert("please enter the url");
        }
        else{
            $('#album_wait_process').show();
            $.ajax({
                type : 'GET',
                url: '/posts/album_scrapping',
                data : { scrap_url : scrap_url , posting_type : posting_type, mention_movie_id : mention_movie_id, mention_artist_id : mention_artist_id, date :date },
                beforeSend:  function(){
                    $(this).html("Wait");
                },
                failure: function(){
                    $('#album_wait_process').html('oops something went wrong... cannot scrap this.. kindly copy paste from site');
                },
                success : function(){
                    window.location.href = "/";
                }

            });
        }
        
    });
}

$(window).bind('hashchange', function(e) {
    e.preventDefault();
    hashChanged();
});

$(document).ready(function() {

	// first hide all the panels
	hashChanged();

	$('.super-fan').click(function() {
        //check if the create div html is empty or not if empty then 
        // get the html and add it to the create div and then call bbq push state
        if ($.trim($("#create").html()) == "") {
            $.ajax({
                url: '/posts/create_popup_code',
                success: function(data) {
                    $("#create").html(data);
                    applyEventsForPopupElements();
                    $.bbq.pushState({"q" : "create"});
                }
            });   
        } else {
            $.bbq.pushState({"q" : "create"});
        }
	});

	// close icon we need to remove the of q
    $("#create").delegate('.close_popup', "click", function() {
        close_popup();
    });

    //closing the pop up by pressing key esc
    $(document).keyup(function(e) {

        if (e.keyCode == 27) { 
            close_popup();
        }   
    });


    // movie, artist and event selection drop down
    $("#create").delegate("#movie_select_dropdown", "click", function() {
    	$("input[name='movie_id']").val($("#movie_select_dropdown").val());
    	var val = $("#movie_select_dropdown").val();

        $.ajax({
            type : 'GET',
            url: '/movies/' + val  + '/get_movie_name',
            data : { val : val }
        });

    	$.bbq.pushState({"q" : $.bbq.getState("q") + "_" + val + "-movie_selection"});
        $(".post-movie-mention").show();
    });

    $("#create").delegate("#artist_select_dropdown", "click" , function() {
    	$("input[name='artist_id']").val($("#artist_select_dropdown").val());
    	var val = $("#artist_select_dropdown").val();

        $.ajax({
            type : 'GET',
            url: '/artists/' + val  + '/get_artist_name',
            data : { val : val }
        });

        $.bbq.pushState({"q" : $.bbq.getState("q") + "_" + val + "-artist_selection"});
        $(".post-artist-mention").show();
    });

    $("#create").delegate("#event_select_dropdown", "click", function() {
        $("input[name='event_id']").val($("#event_select_dropdown").val());
        var val = $("#event_select_dropdown").val();
        $.bbq.pushState({"q" : $.bbq.getState("q") + "_" + val + "-event_selection"});
        $(".post-movie-mention").show();
    });

    var post_fb;
    if ($('#post_to_facebook').is(':checked')) {
        post_fb = 1;
    }
    else{
        post_fb = 0;
    }

    var CKEDITOR_BASEPATH = '/ckeditor/';

    $("#create").delegate("#add-movie", "click", function(){
        $("#cannot-find-movie").hide();
        $(".movie-input-field").show();
    });

    $("#create").delegate("#add-artist", "click", function(){
        $("#cannot-find-artist").hide();
        $(".artist-input-field").show();
    });

    $("#add-event").click(function(){
        $("#cannot-find-event").hide();
        $(".event-input-field").show();
    });

    $("#create").delegate("#new-movie-btn", "click", function(){
        var name = $("#movie-name").val();
        if (name.length != 0) {
            $(this).html("adding");
            $.ajax({
                type : 'POST',
                url: '/movies/user_movie_create',
                data : { name : name },
                beforeSend:  function(){
                    $(this).val("Adding");
                },
                success: function() {
                }
            });
        }
        else {
            alert("enter the movie");
        }
    });
    
    

});
