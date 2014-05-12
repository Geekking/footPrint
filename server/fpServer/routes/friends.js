
var util=require('util');
var connection = require('../models/db.js');

exports.findUser = function(req,res){
	var aimedUserID = req.body.aimedUserID;
	var userID = req.body.userID;
	console.log(req.body);
	var findSql = util.format("SELECT uID AS userID,nickName,personalImg FROM user where user.uID LIKE \'%s\'",aimedUserID);
	console.log(findSql);
	connection.query(findSql,function(err1,res1){
		if(err1){
			console.log(err1);
			res.json({"code":503,
					  "phase":"unknown error"});
		}else{
			if(res1[0]){
				console.log(res1);
				res.json({"code":500,
						"phase":"got the user",
					  "results":res1});
			}
			else{
				res.json({"code":501,
						"phase":"user not found"});
			}
		}
	});
};
exports.addUser = function(req,res){
	
	var userID = req.body.userID;
	var aimedUserID = req.body.aimedUserID;
	var now = new Date();
	var stamp = now.getTime()/1000;
	console.log(stamp);
	var insertSql = util.format("INSERT INTO friendship Value(\'%s\',\'%s\',\'%s\')",userID,aimedUserID,stamp);
	console.log(insertSql);
	connection.query(insertSql,function(error,result){
		if(error){
			res.json({
				"code":553,
				"phase":"unknown error",
			});
			console.log(error);
		}else{
			res.json({
				"code":550,
				"phase":"post user request",
			});
		}

	});
};
exports.getFriends = function(req,res){
	var userID = req.body.userID;
	var friendStamp = req.body.lastFriendStamp;
	console.log(req.body);
	var findSql = util.format("SELECT uID AS frID,nickName,personalImg FROM user WHERE user.uID IN (SELECT friendID FROM friendship WHERE friendship.userID=\'%s\' AND friendship.friendStamp > \'%s\')",userID,friendStamp);
	console.log(findSql);
	connection.query(findSql,function(err1,res1){
		if(err1){
			console.log(err1);
			res.json({"code":503,
					  "phase":"unknown error"});
		}else{
			if(res1)
				res.json({"code":560,
						"phase":"got the friends",
					  "result":res1});
			else{
				res.json({"code":561,
						"phase":"user not found"});
			}
		}
	});

}
