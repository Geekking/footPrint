var util = require('util');
var connection = require('./db');

function User(user){
	this.name = user.name;
	this.password = user.password;
	this.userID = user.userID;
};

module.exports = User;

User.prototype.save = function save(callback){
	var user = {
		name: this.name,
		password: this.password,
		userID: this.userID,
	};
	var insertSQL = util.format('INSERT INTO `user`(`uID`, `unickName`, `uPassword`, `sex`, `age`) VALUES (\'%s\',\'%s\',\'%s\',\'female\',19)',user.userID,user.userID,user.password);
	console.log(insertSQL);	
	connection.query(insertSQL,function (err1, res1) {
        if (err1) {
			console.log(err1);
        	connection.end();
			return callback(err1);
		}
		console.log("INSERT Return ==> ");
        console.log(res1);
		return callback(err1);
	});

};

User.get = function get(userID,callback){
	var selectSQL = util.format('SELECT `uID`,`uPassword` FROM `user` WHERE user.uID =\'%s\'',userID);
	connection.query(selectSQL,function(err1,res1){
		console.log(selectSQL);
		if(err1) {
			connection.end();
			return callback(err1);
		};
		if ( res1[0]){
			callback(err1,res1[0]);
		}else{
			callback(err1,null);
		}
	});
};

