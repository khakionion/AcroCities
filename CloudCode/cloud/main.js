var generateRandomAcronym = function (length) {
	var answer = "";
	for(var i=0;i<length;++i) {
		answer+=String.fromCharCode(65+Math.floor(Math.random()*26));
	}
	return answer;
}
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("startGame", function (request, response) {
	var gameQuery = new Parse.Query("Game");
	gameQuery.equalTo("objectId",request.params.gameID);
	gameQuery.find({
		success: function(results) {
			if(results.length == 1) {
				var game = results[0];
				console.log(game);
				if(!game.has("acronym")) {
					var acronym = generateRandomAcronym(5);
					game.set("acronym",acronym);
					game.save();
				}
				response.success(game.get("acronym"));
			}
			else {
				response.error("Improper number of games returned.");
			}
		},
		error: function() {
			response.error("game lookup failed");
		}
	});
});
