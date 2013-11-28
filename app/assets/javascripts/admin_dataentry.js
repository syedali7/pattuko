
$(document).ready(function(){
/*news_urls ui code */
    

             
                $('input[id^="artist_select_dropdown-"]').each(function(){
                    $(this).select2({
                        placeholder: "Search for a Artist",
                        multiple : true,
                        minimumInputLength: 1,
                        id: function(data) {
                            return data.id;
                        },
                        ajax: {
                            url: "/admin/movies/get_artists.json",
                            dataType: 'json',
                            data: function (term, page) {
                                return {
                                    q: term,
                                    page_limit: 10
                                };
                            },
                            results: function (data, page) {

                                return {results: data.artists, more: (data.artists.length == 10 ? true: false)};
                            }
                        },
                        formatResult: artistFormatResult,
                        formatSelection: artistFormatSelection,
                        dropdownCssClass: "bigdrop",
                        escapeMarkup: function (m) {
                            return m;
                        }
                    })
                });


            function artistFormatResult(artist) {
                var markup = "<table class='movie-result'><tr>";
                markup += "<td class='movie-info'><div class='movie-title' id='"+ artist.id +"'>" + artist.name + "</div>";
                markup += "</td></tr></table>"
                return markup;
            }

            function artistFormatSelection(artist) {
                return artist.name;
            }

            $("button[id^='movie_artist_update-']").live('click',function(){
                var movie_id = $(this).attr('id').split('-')[1]
                var score = $("#movie_score-"+movie_id).val()
                alert(score)
                var artist_scores = []
                $('input[id^="artist_score-'+movie_id+'-"]').each(function(){
                    var artistscores
                    var artist_type_id
                    if($(this).val() != ""){
                         artistscores = $(this).val().split(',')
                         //alert(artistscores)
                        artist_type_id = $(this).attr('id').split('-')[2];
                        //alert(artist_type_id)
                        artist_scores.push({artist_type_id : artist_type_id,  artistscores :  artistscores })
                    }    
                    else{
                        artistscores = $(this).val()
                        artist_type_id = $(this).attr('id').split('-')[2];
                        artist_scores.push({artist_type_id : artist_type_id,  artistscores : artistscores })
                        //alert(artist_type_id)
                    }
                });
                //alert(score)
                var realesed_date = $("#realeased_date-"+movie_id).val()
                var exp_date = $("#exp_date"+movie_id).val()
                //var a = [1,4,27,28]
                var movie_artists = [];
                $('input[id^="artist_select_dropdown-'+movie_id+'-"]').each(function(){
                     var artist_ids ;
                     var artist_type_id ;
                    if ($(this).val() != ""){
                         artist_ids = $(this).val().split(',');
                         artist_type_id = $(this).attr('id').split('-')[2];
                         movie_artists.push({artist_type_id : artist_type_id, artist_ids : artist_ids});
                    }
                });
                
               $.ajax({
                    url : '/admin/movies/movie_artist_update',
                    type: 'post',
                     data : { movie_artists: movie_artists , movie_id: movie_id ,score: score, realesed_date: realesed_date, exp_date: exp_date ,artist_scores: artist_scores},
                    success : function(){
                        $("#movie_artist_update-"+movie_id).text("success");
                      
                    }
                });
                
                
            });

        $('#movies1').change(function(){
            var movie_id = $(this).val();
            $('#description').show();
            var description = $('#description').val();
            $.ajax({
                type : 'get',
                url : '/admin/movies/movie_select',
                data : { movie_id : movie_id },
                success : function(data){
                    
                   $('.movie_id').html(data);

                  $('input[id^="artist_select_dropdown-"]').each(function(){
                    
                    $(this).select2({
                        placeholder: "Search for a Artist",
                        multiple : true,
                        minimumInputLength: 1,
                        id: function(data) {
                            return data.id;
                        },
                        ajax: {
                            url: "/admin/movies/get_artists.json",
                            dataType: 'json',
                            data: function (term, page) {
                                return {
                                    q: term,
                                    page_limit: 10
                                };
                            },
                            results: function (data, page) {

                                return {results: data.artists, more: (data.artists.length == 10 ? true: false)};
                            }
                        },
                        formatResult: artistFormatResult,
                        formatSelection: artistFormatSelection,
                        dropdownCssClass: "bigdrop",
                        escapeMarkup: function (m) {
                            return m;
                        }
                    })
                });
            }
        });
    });
});