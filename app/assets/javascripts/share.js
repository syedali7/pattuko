$(document).ready(function(){
    var image_id = null;
    $("#movie_id").hide();
    $("#artist_id").hide();

    /*$('#tag_select').click(function(){
        if($(this).children("input[checked='checked']").val() == 'Movie') {
            tagable_type='Movie';
            $("#movie_id").show();
            $('#artist_id').hide();
        }
        else{
            tagable_type = 'Artist';
            $("#movie_id").hide();
            $("#artist_id").show();
        }
    });*/

    $('#discussions_image').fileupload();

    function imageVal(){
      if($('#disc_img').get(0)){
          image_id = $('#disc_img').val();
      }
       return image_id;
    }


    $('.share_send_btn').click(function(){
        var title=$('.share_title_inpt').val();
        var discription=$('.share_desc_inpt').val();
        var user_id=$('#user_id').val();
        var movies = "";
        var artists = "";
        $('input.share_title_inpt').mentionsInput('getMentions', function(tagging) {
            for(i = 0; i < tagging.length; i++) {
                if(tagging[i].type == 'Movie') {
					movies = movies+tagging[i].id + ',';
                }
                else {
					artists = artists+tagging[i].id + ',';
                }
            }
        });
//        $('.share_items').append("<img src='/assets/select2-spinner.gif' >");        
        $('.selected_item_area').html("<p>sending........ </p><img src='/assets/select2-spinner.gif' >");
         $.ajax({
            type: 'POST',
            url : '/discussions',
            data : {
            	title: title,
            	discription: discription,
            	image_id: imageVal(),
            	user_id: user_id,
            	movies: movies,
            	artists: artists
            },
            success: function(data){
            	$('.selected_item_area').text(data);
              	window.location.assign('/discussions')
            },
            failure: function(data){
                alert('some thing went wrong ..........');
            },            
         });
    });

    $('input.share_title_inpt').mentionsInput({
      onDataRequest:function (mode, query, callback) {
      	//query = query + "*";
      	var url = "http://www.pattuko.com:9200/movies,artists/movie,artist/_search";
      	var query_data = {"wildcard": {"name": query}};
        $.ajax({
            type: 'GET',
            url: 'http://www.pattuko.com:9200/movies,artists/movie,artist/_search',
            data: {"fields" : ["name"], "query"  : query_data , "from": 0,"size":20 },
            success:function(data){
            	console.log(data);
                data = _.filter(data, function(item) { return item.name.toLowerCase().indexOf(query.toLowerCase()) > -1 });
                callback.call(this, data);
            }
        });

      }
    });

    
    $('.dummy_class_btn').bind('change', function() {
        $('#submit-btn').trigger('click');
    });
    
    /***************** show upload button script******************/
    $('.share_items').toggle(function(){
        $('.dummy_class_btn').trigger('click');    
        $('.show_hide_area').show(200);
    },function() {
        $('.show_hide_area').hide();
    });

    $('#discussions_image').bind('change',function(){
        $('.selected_item_area').html("<p>Uploading image </p><img src='/assets/select2-spinner.gif' >");
    });
    
    /***************** show share popup script******************/
    $('.share_btn').toggle(function(){
        $('.share_popup').show();
    },function() {
        $('.share_popup').hide();
    });
    /******shar button end******/
});