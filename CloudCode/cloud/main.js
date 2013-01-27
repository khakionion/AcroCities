var generateRandomAcronym = function (length) {
	var answer = "";
	for(var i=0;i<length;++i) {
		answer+=String.fromCharCode(65+Math.floor(Math.random()*26));
	}
	return answer;
}

Parse.Cloud.beforeSave("Game", function (request, response) {
	var game = request.object;
	if(!game.has("acronym")) {
		var acronym = generateRandomAcronym(5);
		game.set("acronym",acronym);
	}
	response.success();
});
