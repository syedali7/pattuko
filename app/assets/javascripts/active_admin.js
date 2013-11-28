//= require active_admin/base
//= require chosen.jquery
//= require select2
//= require admin_dataentry
//= require common

$(document).ready(function(){
	$('#movie_artist_ids').chosen();
	$('#artist_type_artist_ids').chosen();
	$('#hero').chosen();
	$('#heroine').chosen();
	$('#villain').chosen();
	$('#comedian').chosen();
	$('#character_artist').chosen();
	$('#review_movie_id').chosen();
	$('#review_website_id').chosen();
    $('#movie').chosen();
    $('#style_artist_id').chosen();
    $('#style_movie_id').chosen();
    $('#movie_event_tag').chosen();
    $('#artist_event_tag').chosen();
    $('#description').hide();

    $('#review_website_id').change(function(){
        var website_id = $(this).val();
        var movie_id = $('#review_movie_id').val();
        if (movie_id.length == 0) {
            alert("please select the movie first");    
        }
        else {
            $.ajax({
                type : 'post',
                url : '/admin/reviews/get_review_details',
                data : {movie_id : movie_id, website_id : website_id }
            });
        }
    });

    $('#movie').change(function(){
        var movie_id = $(this).val();
        $('#description').show();
        var description = $('#description').val();
        $.ajax({
            type : 'post',
            url : '/admin/movies/get_movie_details',
            data : { movie_id : movie_id },
            success : function(data){
                $('.movie_details').html(data);
                $('input[id^="edit_movie_artist-"]').each(function(){
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

    $('.del_artist_type').click(function(){
        var accepted= window.confirm('are you sure! you want to delete this? '),ma=$(this)
        if(accepted==true){
           $.ajax({
              type : 'GET',
              url  : '/admin/artists/id/artist_movies',
              data : { delete_ma : true, ma : $(ma).attr('id') },
              success :function(){
                alert('successfully deleted :-) ');
                $(ma).hide();
              },
              failure :function(){
                alert('something went wrong.........');
              }
           });
        }

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

    $('#update_movie_artist').click(function(){
        var description = $('#description').val();
        /*$('#update_movie_artist').hide();*/
        $('.message').show();
        var movie_id = $('#movie').val();
        var movie_artists = [];
        $('input[id^="edit_movie_artist-"]').each(function(){
             var artist_ids ;
             var artist_type_id ;
            if ($(this).val() != ""){
                 artist_ids = $(this).val().split(',');
                 artist_type_id = $(this).attr('id').split('-')[1];
                 movie_artists.push({artist_type_id : artist_type_id, artist_ids : artist_ids});
            }
        });

        $.ajax({
            url : '/admin/movies/update_movie_artist',
            type: 'post',
            data : { movie_id : movie_id, movie_artists : movie_artists, description : description },
            success : function(){
                setTimeout(function(){
                    window.location = '/admin/movies/bulk_edit';
                }, 2000);
            }
        });

    });

    $('#create_event').click(function(){
        var name = $("#name").val();
        var movie_id = $('#movie_event_tag').val();
        var artist_id = $('#artist_event_tag').val();
        var trimtext = name.trim();
        if (trimtext == "") {
            alert("please add the event name");
        }
        else {
            $(this).hide();
            $.ajax({
                url : '/admin/events/create_event',
                type: 'post',
                data : { movie_id : movie_id, artist_id :artist_id, name :name },
                success : function(){
                    window.location = '/admin/events/create_event_form';
                }   
            });
        }
    });


    $("form.button_to").submit(function(){
        $(this).html('<p>Processing request.......</p>');
    });


    $('#movie_event').click(function(){
        $(".artist_event_select").hide();
        $(".movie_event_select").show();
        $("#artist_event").hide();
    });

    $('#artist_event').click(function(){
        $(".artist_event_select").show();
        $(".movie_event_select").hide();
        $("#movie_event").hide();
    });
    function autoLoad(){
        if($('#na_request').val()!=false){
               var na=$('#na_request').val()
               $('#movie').val(na).children('option[value=' + na + ']').attr('selected',true);
        }
    }

});
 
