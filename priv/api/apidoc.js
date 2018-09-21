/**
 *
 * @api {get} /v1/leagues/ Request available leagues
 * @apiName GetLeagues
 * @apiGroup Scores
 *
 * @apiSuccess {List} leagues Available leagues to be requested
 *
 * @apiExample {curl} Example usage:
 *     curl -i http://localhost/v1/leagues/
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "leagues": [
 *          "sp1",
 *          "d1",
 *          "o0"
 *        ]
 *     }
 */

 /**
 * @api {get} /v1/leagues/:league/seasons/ Request available seasons for the league
 * @apiName GetSeasons
 * @apiGroup Scores
 *
 * @apiParam {Sring} league League unique name.
 *
 * @apiSuccess {String} league League name used in the request
 * @apiSuccess {List} seasons Seasons available for the requested league
 *
 * @apiExample {curl} Example usage:
 *     curl -s http://localhost/v1/leagues/sp1/seasons
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "league" : "sp1",
 *       "seasons" : [
 *                    "201516",
 *                    "201617"
 *                   ]
 *     }
 *
 * @apiErrorExample {json} Error-Response:
 *     HTTP/1.1 404 Not Found
 *     {
 *       "error": "LeagueNotFound"
 *     }
 *
 */

 /**
 * @api {get} /v1/leagues/:league/seasons/:season/scores Request Scores for the provided league and season
 * @apiName GetScores
 * @apiGroup Scores
 * 
 * @apiParam {Sring} league League unique name.
 * @apiParam {Sring} season Season year, i.e. 201617, 201718.
 * 
 * @apiSuccess {String} league League name used in the request
 * @apiSuccess {String} season Season used in the request
 * @apiSuccess {List} scores Data for the selected league and season
 * @apiSuccess {String} scores.date Date of the match
 * @apiSuccess {String} scores.home_team Home team name
 * @apiSuccess {String} scores.away_team Visiting team name
 * @apiSuccess {Integer} scores.fthg Full time home team goals
 * @apiSuccess {Integer} scores.ftag Full time away team goals
 * @apiSuccess {String} scores.ftr Full time result (H=Home Win, D=Draw, A=Away Win)
 * @apiSuccess {Integer} scores.hthg Half time home team goals
 * @apiSuccess {Integer} scores.htag Half time away team goals
 * @apiSuccess {String} scores.htr Half time result (H=Home Win, D=Draw, A=Away Win)
 *
 * @apiExample {curl} Example usage:
 *     curl -s http://localhost/v1/leagues/sp1/seasons/201617/scores
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "league" : "sp1",
 *       "season" : "201617",
 *       "scores" : [
 *                   { 
 *                    "date" : "19/08/16",
 *                    "home_team" : "La Coruna",
 *                    "away_team" : "Eibar",
 *                    "fthg" : 2,
 *                    "ftag" : 1,
 *                    "ftr" : "H",
 *                    "hthg" : 0,
 *                    "htag" : 0,
 *                    "htr" : "D"
 *                   },
 *                   { 
 *                    "date" : "19/08/16",
 *                    "home_team" : "Malaga",
 *                    "away_team" : "Osasuna",
 *                    "fthg" : 1,
 *                    "ftag" : 1,
 *                    "ftr" : "D",
 *                    "hthg" : 0,
 *                    "htag" : 0,
 *                    "htr" : "D"
 *                   }
 *                  ]
 *     }
 *
 * @apiErrorExample {json} Error-Response:
 *     HTTP/1.1 404 Not Found
 *     {
 *       "error": "SeasonNotFound"
 *     }
 *
 */
