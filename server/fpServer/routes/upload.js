/*
	handle new fp
	Create by apple on 03/02/2014 
	Copyright (c) 2014 SYSU.All rights reserved.
	
*/

var util = require('util');
var fs = require('fs');

exports.newFP = function(req,res,next){
	console.log('files', req.files);
	var filePath = req.files.file.path;
	console.log('file has already locate in ',filePath);
	console.log(req.header);
	console.log(req.body);
	res.json({message: "xxx"});
}
