var acronymRounds = [3,3,4,4,5];

var generateRandomAcronym = function (length) {
	var answer = "";
	for(var i=0;i<length;++i) {
		answer+=String.fromCharCode(65+Math.floor(Math.random()*26));
	}
	return answer;
}

Parse.Cloud.beforeSave("Game", function (request, response) {
	var game = request.object;
	var acronyms = game.get("acronyms") || [];
	if(acronyms.length >= acronymRounds.length) {
		//this round is expired
	}
	else {
		var acronymLength = acronymRounds[acronyms.length];
		var acronym = generateRandomAcronym(acronymLength);
		acronyms.push(acronym);
		game.set("acronyms", acronyms);
	}
	response.success();
});
