
/*
 * GET users listing.
 */

var connection = require('../models/db');
var util = require('util');
exports.list = function(req, res){
  res.send("respond with a resource");
};

exports.getPersonInfo = function(req,res,next){
	var queryUserID = req.body.queryuserID;
	var selectSql = util.format("SELECT `uID` AS `userID`, `nickName`, `uPassword`, `sex`, `age`, `personalImg` FROM `user` WHERE uID = \'%s\'",queryUserID);
	connection.query(selectSql,function(err1,res1){
		if(err1){
			console.log("query person info error\n",err1);
			 console.log(selectSql);
			 res.json({
				"code":104,
				"phase":"database error"
			});
		}else{
			if(res1){
				res.json({
					"code":640,
					"phase":"query user found",
					"userInfo":res1
				});
			}else{
				res.json({
					"code":641,
					"phase ":"query user not found"
				});
			}
		}
	});
};
