$(document).ready(function() {

	$("input[id^='movie_select_dropdown-']").select2({
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

     
    $("input[id^='artist_select_dropdown-']").select2({
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

    $("button[id^='news_scraping-']").click(function(){
    	var data = {};
        var id = $(this).attr('id').split('-')[1];

        data.news_url_id = id;

        //alert(id)
        if ($('#movie_select_dropdown-'+id).val() == "" && $('#artist_select_dropdown-'+id).val() == "") {
            alert("select any one in movie and artist");
        } else {
        	data["image_url"] = $("#image_url-"+id).val();

            if ($('#movie_select_dropdown-'+id).val() != "") {
            	data["posting_type"] = "movie";
                data["posting_id"] = $('#movie_select_dropdown-'+id).val();
            } else {
            	data["posting_type"] = "artist";
            	data["posting_id"] = $('#artist_select_dropdown-'+id).val();
            }
                
            $.ajax({
                type : 'GET',
                url: '/posts/news_scrapping',
                data : data,
                beforeSend:  function(){
                    $('#news_scraping-'+id).text("Adding");
                },
                failure: function(){
                    $('#wait_process').html('oops something went wrong... cannot scrap this.. kindly copy paste from site');
                },
                success : function(){
                    $('#news_scraping-'+id).text("success");
                    //window.location.href = "/";
                }
            });
        }        

    });

    $("a[id^='delete-']").click(function(){
        //alert("r u sure");
        var id = $(this).attr("id").split('-')[1]
        $.ajax({
            type :'POST',
            url:'/newsurls/newsurl_delete',
            data:{ id : id },
            success : function(){
                $("#table-"+ id).remove();
            }

        });
    });
});