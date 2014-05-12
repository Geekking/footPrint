var util = require('util');
var connection = require('./db');

function User(user){
	this.name = user.name;
	this.password = user.password;
	this.userID = user.userID;
	this.nickName = user.nickName;
};

module.exports = User;

User.prototype.save = function save(callback){
	var user = {
		name: this.name,
		password: this.password,
		userID: this.userID,
		nickName:this.nickName
	};
	console.log(user);
	var insertSQL = util.format('INSERT INTO `user`(`uID`, `nickName`, `uPassword`, `sex`, `age`) VALUES (\'%s\',\'%s\',\'%s\',\'female\',19)',user.userID,user.nickName,user.password);
	connection.query(insertSQL,function (err1, res1) {
        if (err1) {
			console.log(err1);
			return callback(err1);
		}
		return callback(err1);
	});

};

User.get = function get(userID,callback){
	var selectSQL = util.format('SELECT `uID`,`uPassword` FROM `user` WHERE user.uID =\'%s\'',userID);
	connection.query(selectSQL,function(err1,res1){
		if(err1) {
			return callback(err1);
		};
		if ( res1[0]){
			callback(err1,res1[0]);
		}else{
			callback(err1,null);
		}
	});
};
exports.getPersonInfo = function(req,res,next){
	var queryuserID = req.body.queryuserID;
	var selectSql = util.format('SELECT `uID` AS `userID`,`nickName`,`personalImg` WHERE user.uID = \'%s\'',queryuserID);
	console.log(selectSql);
	connection.query(selectSql,function(err1,res1){
		if(err1){
			console.log("databae error:",err1);
			console.log(selectSql);
			return res.json({
				"code":104,
				"phase":"database error"
			});
		}else{
			if(res1[0]){
				return res.json({
					'code':640,
					'phase':'query user found',
					'userInfo':res1
				});
			}else{
				return res.json({
					"code":641,
					"phase":"query user not found"
				});
			}
		}
	});
};
