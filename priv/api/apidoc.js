/**
 *
 * @api {get} /v1/leagues/ Request available leagues
 * @apiName GetLeagues
 * @apiGroup Scores
 *
 * @apiSuccess {List} leagues Available leagues to be requested
 *
 * @apiExample {curl} Example JSON usage:
 *     curl -s http://localhost/v1/leagues/
 *
 * @apiExample {curl} Example Proto Buffers usage:
 *     curl -s -H 'accept: application/x-protobuf' http://localhost:8080/v1/leagues/ | hexdump 
 *
 * @apiSuccessExample Success-Response (JSON):
 *     HTTP/1.1 200 OK
 *     {
 *       "leagues": [
 *          "sp1",
 *          "d1",
 *          "o0"
 *        ]
 *     }
 *
 * @apiSuccessExample Success-Response (Proto Buffers piped to hexdump):
 * 
 * 0000000 0108 0412 020a 3164 0412 020a 3065 0512
 * 0000010 030a 7073 1231 0a05 7303 3270          
 * 000001c
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
 *         "201516",
 *         "201617"
 *       ]
 *     }
 *
 * @apiErrorExample {json} Error-Response:
 *     HTTP/1.1 404 Not Found
 *     {
 *       "error": "NotFound"
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
 *       "count": 1,
 *       "league" : "sp1",
 *       "season" : "201617",
 *       "scores" : [
 *         {
 *           "away_team": "Levante",
 *           "date": "15/05/16",
 *           "ftag": 1,
 *           "fthg": 3,
 *           "ftr": "H",
 *           "home_team": "Vallecano",
 *           "htag": 0,
 *           "hthg": 2,
 *           "htr": "H"
 *          }
 *        ]
 *     }
 *
 * @apiErrorExample {json} Error-Response:
 *     HTTP/1.1 404 Not Found
 *     {
 *       "error": "NotFound"
 *     }
 *
 */
