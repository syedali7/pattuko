$(document).ready(function() {
	$("#movie_select_dropdown_style").click(function() {
	    $("input[name='style_movie_id']").val($("#movie_select_dropdown_style").val());
	});

	$("#artist_select_dropdown_style").click(function() {
	    $("input[name='style_artist_id']").val($("#artist_select_dropdown_style").val());
	});

	$("#movie_select_dropdown_style").select2({
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

	$("#artist_select_dropdown_style").select2({
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

	$("button[id^='style_edit_']").live('click', function(){
	    var style_id = $(this).attr("id").split("_")[2];
	    $('#style_edit_' + style_id).hide();
	        //$('#edit_style').css({'position':'absolute','top':'200px','left':'300px','z-index':'1','background-color':'#75A3FF','width':'650px'}).show();
	        $('#edit_style_' + style_id).show();
	    });

	$('#movie_update_style').live("click",function(){
	    var style_id = $(this).attr('data-id');
	    $('#sub_edit_movie_style_'+ style_id).show();
	    $('#style_form_' + style_id).show();
	});

	$('#artist_update_style').live("click",function(){
	    var style_id = $(this).attr('data-id');
	    $('#sub_edit_artist_style_'+style_id).show();
	    $('#style_form_' + style_id).show();
	});

	$('.finish').click(function(){
	    var style_movie_id_parsed = $('#style_movie_id_parsed').val();
	    var style_artist_id_parsed = $('#style_artist_id_parsed').val();
	    var style_id_parsed = $('#style_id_parsed').val();

	    $.ajax({
	        type : 'POST',
	        url : '/shop/style_update',
	        data : { style_id : style_id_parsed, style_movie_id : style_movie_id_parsed,
	           style_artist_id : style_artist_id_parsed },
	           success : function(){
	            window.location.href = '/shop';
	        }
	    });
	    console.log('farsvc');
	});
})