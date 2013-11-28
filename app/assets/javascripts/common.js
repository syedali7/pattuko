ENVIRONMENT = "dev";
PORT_NO = ":9200";
DOMAIN_NAME = document.domain;


if (document.domain == "www.pattuko.com" && location.port == "") {
	ENVIRONMENT = "prod";
}

function getPostsSearchUrl() {
	var indexName = ENVIRONMENT == "dev" ? "dev_posts" : "posts";
	return "http://" + document.domain + PORT_NO + "/" + indexName + "/post/_search";
}

function getArtistsSearchUrl() {
	var indexName = ENVIRONMENT == "dev" ? "dev_artists" : "artists";
	return "http://" + document.domain + PORT_NO + "/" + indexName + "/artist/_search";
}

function getMoviesSearchUrl() {
	var indexName = ENVIRONMENT == "dev" ? "dev_movies" : "movies";
	return "http://" + document.domain + PORT_NO + "/" + indexName + "/movie/_search";
}

function getRelatedPostsSearchUrl() {
	var indexName = ENVIRONMENT == "dev" ? "dev_related_posts" : "related_posts";
	return "http://" + DOMAIN_NAME + PORT_NO + "/" + indexName + "/related_post/_search";
}

// post url refresh and it should go to the post show page
if (window.location.hash.substring(1).indexOf("p=") == 0) {
	var tmp = window.location.hash.substring(1).split("p=");
	document.location.href = tmp[1];
}