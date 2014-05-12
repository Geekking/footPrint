/*
 * Copyright by Mude
 * 2014-05-06
 *
 */

var util = require('util');
var connections = require('../models/db');
var crypto = require('crypto');
var commentModel = require('../models/commentModel');

exports.commentOnFP = function(req,res,next){
	var comment = new commentModel({
		FPID : req.body.FPID,
		userID : req.body.commentUserID,
		commentTime : req.body.commentTime,
		commentLocation : req.body.commentLocation,
		commentPosition : req.body.commentPosition,
		commentContent : req.body.commentContent
	});
	comment.save(function(err){
		if(err){
			console.log("comment Error",err);
			return res.json({
					"code":621,
					"phase":"comment failed"
			});
		}else{
			return res.json({ 

					"code":620,
					"phase":"comment success"
				});
		}
	});
};
exports.getCommentOfFP = function(req,res,next){
	var fpID = req.body.queryFPID;
	commentModel.get(fpID,function(err1,res1){
		if(err1){
			console.log("get comment of fp error\n",err1);
			return res.json({
				"code":104,
				"phase":"databse error"
			});
		}else{
			if(res1[0]){
				return res.json({
					"code":630,
					"phase":"comment found",
					"results":res1
				});
			}else{
				return res.json({
					"code":631,
					"phase":"comment not found"
				});
			}
		}
	});
};
