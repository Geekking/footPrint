
var util = require('util');
var connection = require('./db');

function FootPrint(fp){
	this.userID = fp.userID;
	this.description = fp.description;
	this.videoTime = fp.videoTime;
	this.position = fp.position;
	this.loc = 		fp.loc;
	this.imageUrl = fp.imageUrl;
	this.informUsers = fp.informUsers;
	this.movieUrl = fp.movieUrl;
};

module.exports = FootPrint;

FootPrint.prototype.save = function(callback){
	var fp = {
		userID: this.userID,
		description: this.description,
		videoTime: this.videoTime,
		position: this.position,
		loc: this.loc,
		imageUrl: this.imageUrl,
		informUsers:this.informUsers,
		movieUrl: this.movieUrl,
		
	};
	var insertSQL = util.format('INSERT INTO `footPrint`(`uID`, `descript`, `secureType`, `location`, `position`, `infouIDs`, `videoTime`, `movieUrl`,`imageUrl`) VALUES  (\'%s\',\'%s\',\'..\',\'%s\',\'%s\',\'%s\',\'%s\',\'%s\',\'%s\')',fp.userID,fp.description,fp.loc,fp.position,fp.informUsers,fp.videoTime,fp.movieUrl,fp.imageUrl);
	connection.query(insertSQL,function(err1,res1){
		if (err1){
			return callback(err1);
		};
		return callback(err1);
	});
};
FootPrint.get = function get(fpID,callback){
	var selectSQL = util.format(' SELECT `fpID` FROM `footPrint` WHERE footPrint.fpID = \'%s\'',fpID);
	connection.query(selectSQL,function(err1,res1){
		if (err1){
			return callback(err1);
		};
		if (res1[0]){
			callback(err1,res1[0]);
		}else{
			callback(err1,null);
		}
	});
};
FootPrint.refreshFP = function refreshFP(userID,lastfpID,callback){
	var selectSQL = util.format('SELECT * FROM `footPrint` WHERE footPrint.uID = \'%s\' AND footPrint.fpID > \'%s\'',userID,lastfpID);
	connection.query(selectSQL,function(err1,res1){
		if(err1){
			console.log(err1);
			return callback(err1);	
		}
		if (res1[0]){
			callback(err1,res1);	
		}else{
			callback(err1,null);
		}
	});
};
