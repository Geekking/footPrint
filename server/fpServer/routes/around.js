
/*get near footprints 
 *
 *copywrite by apple 2014/4/27
 */

var util = require('util');
var connection = require('../models/db');
/*search near footprints
 *1, find the user's friends
 *2, get all the footprints
 *3, filter the footprints according to the time and location
 *
 *
 */
exports.searchNearFP = function(req,res,next){
	var userID = req.body.userID;
	var reqStamp = req.body.requestTimestamp;
	var direction = req.body.direction;
	var coor = req.body.location;
	if( direction == "1")
		direction = ">";
	else{
		direction = "<";
	}
	var selectSql = util.format('SELECT * FROM footPrint fp WHERE fp.uID IN (SELECT friendID FROM friendShip WHERE userID  = \'%s\' ) AND (fp.videoTime %s %s) LIMIT 1,20;',userID,direction,reqStamp);
	connection.query(selectSql,function(err1,res1){
		if(err1){
			console.log("Search Near FP error");
			console.log(err1);
			res.json({
				"code":601,
				"phase":"error"
			});
		}else{
			console.log("Near FP found");
			res1 = filterAccordingToCoor(res1,coor);
			
			res.json({
				"code":600,
				"phase":"Success get some new fps:",
				"results":res1,					
				});
		}
	});
}
	function filterAccordingToCoor(res1,coor){
		maxDistance = 50;
		coor = coor.split(",");
		lat1 = coor[0];
		lng1  = coor[1];
		aimFP = [];
		for (var i = 0; i < res1.length; i++) {
			coor2 = res1[i]["location"].split(',')
			lat2 = coor2[0];
			lng2 = coor2[1];
			dis = getGreatCircleDistance(lat1,lng1,lat2,lng2);
			if (dis <= maxDistance) {
				aimFP.push(res1[i]);
			};
		};
		return aimFP;
	}
	var EARTH_RADIUS = 6378137.0;    //单位M

    var PI = Math.PI;

    

    function getRad(d){

        return d*PI/180.0;

    }

    function getGreatCircleDistance(lat1,lng1,lat2,lng2){

        var radLat1 = getRad(lat1);

        var radLat2 = getRad(lat2);

        

        var a = radLat1 - radLat2;

        var b = getRad(lng1) - getRad(lng2);

        

        var s = 2*Math.asin(Math.sqrt(Math.pow(Math.sin(a/2),2) + Math.cos(radLat1)*Math.cos(radLat2)*Math.pow(Math.sin(b/2),2)));

        s = s*EARTH_RADIUS;

        s = Math.round(s*10000)/10000.0;

                

        return s;

    }
