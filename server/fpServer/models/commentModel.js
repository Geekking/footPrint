

var util = require('util');
var connection = require('./db');

function commentModel(comment){
	this.FPID = comment.FPID;
	this.userID = comment.userID;
	this.commentContent = comment.commentContent;
	this.commentTime = comment.commentTime;
	this.commentLocation = comment.commentLocation;
	this.commentPosition = comment.commentPosition;
};

module.exports = commentModel;

commentModel.prototype.save = function(callback){
	var insertSQL = util.format("INSERT INTO `Comment`(`FPID`, `UserID`, `commentLocation`, `commentPosition`, `commentContent`, `commentTime`) VALUES (\'%s\',\'%s\',\'%s\',\'%s\',\'%s\',\'%s\')",this.FPID,this.userID,this.commentLocation,this.commentPosition,this.commentContent,this.commentTime);

	connection.query(insertSQL,function(err1,res1){
		if(err1){
			console.log("Comment save into databse error\n",err1);
			callback(err1);
		}else{
			callback(err1);
		}
	});
};
commentModel.get = function(fpID,callback){
	var selectSql = util.format("SELECT `commentID`, `FPID`, `UserID` AS `commentUserID`, `commentLocation`, `commentPosition`, `commentContent`, `commentTime` FROM `Comment` WHERE  FPID = \'%s\'",fpID);
	connection.query(selectSql,function(err1,res1){
		if(err1){
			console.log("comment query error",err1);
			callback(err1);
		}else{
			callback(err1,res1);
		}
	});
};
