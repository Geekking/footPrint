/*
	handle new fp
	Create by apple on 03/02/2014 
	Copyright (c) 2014 SYSU.All rights reserved.
	
*/

var util = require('util');
var fs = require('fs');
var connection = require('../models/db');
var crypto = require('crypto');
var FootPrint = require('../models/FootPrint');

exports.newFP = function(req,res,next){
	var filePath = req.files.image.path;
	
	var movFilePath;
	if(req.files.movie){
		movFilePath = req.files.movie.path;
	}else{
		movFilePath = "/undefine";
	}
	var arr = filePath.split('/');
	filePath = arr[arr.length -1];
	arr = movFilePath.split('/');
	movFilePath = arr[arr.length-1];

	var newFP = new FootPrint({
		userID:     req.body.userID,
		description: req.body.description,
		videoTime:   req.body.videoTime,
		position:    req.body.position,
		loc:    	 req.body.coordinate,
		informUsers: req.body.informUserList,
		imageUrl:     filePath,
		movieUrl:     movFilePath,
	});
	newFP.save( function(err){
		if(err){
			return res.json({
				'code':401,
				'phase':'cannot upload',
			});
		}
		res.json({
				"code":400,
			  "phase":"post success",
		});
	});
	
}

exports.refreshFP = function(req,res,next){
	var lastFPID = req.body.lastFPID;
	var userID = req.body.userID;
	FootPrint.refreshFP(userID,lastFPID,function(err,result){
		if(err){
			return res.json({
				"code":451,
				"phase":"cannot refresh",
			});
		}
		if( result ){
			console.log(result);
			return res.json({
				"code":450,
				"phase":"got some new message",
				"result":result
			});
		}
		return res.json({
			"code": 452,
			"phase": " no new foot print"
		});
	});
}
