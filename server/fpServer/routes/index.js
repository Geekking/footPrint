
/*
 * GET home page.
 */

var connection = require('../models/db');
var crypto = require('crypto');
var User = require('../models/User.js');

exports.index = function(req, res){
  res.render('index', { title: 'Express' });
};

exports.checkLogin = function(req,res,next){
	if (!req.session.user){
		//TODO: not logoin
		console.log(req.session.user.userID);
		return res.json({
			'code': 101,
			'phase':'user not login'
		});
	}
	next();
}

exports.logIn = function(req,res,next){
	if (req.session.user){
		console.log(req.session.user);
		return res.json({
			'code': 301,
			'phase': 'user has already login',
		});
	}
	var md5 = crypto.createHash('md5');
	var password = md5.update(req.body.password).digest('base64');
	User.get(req.body.userID,function(err,user){
		if(err){
			console.log(err);
		};
		if(!user){
			return res.json({
				'code' :302,
				'phase':'user not exist'
			});
		}
		if(password != user.uPassword){
			return res.json({
				'code' :303,
				'phase':'password not match'
			});
		}
		console.log(user);
		req.session.user = user;
		return res.json({
			'code' :300,
			'phase':'ok'	
			});
	
		});
}
exports.registe = function(req,res,next){
	console.log(req.body);
	var md5 = crypto.createHash('md5');
	var password = md5.update(req.body.password).digest('base64');

	var newUser = new User({
		userID:	  req.body.userID,
		name:     req.body.userName,
		password: password,
		nickName: req.body.nickName
	});
	console.log(newUser.userID);
	User.get(newUser.userID,function(err,user){
		if(user){
			err = 'User already exists.';
		};
		console.log(err);
		if (err){
			return res.json({
				'code' :201, 
				'phase':err,});	
		};
		newUser.save(function(err){
			if(err){
				return res.json({
					'code':202,
					'phase':err,
				});
			}
//			req.session.user = newUser;
			console.log('registe success',newUser);
			return res.json({
					'code':200,
					'phase':err,
				});
		});
			
	});
}
exports.logOut = function(req,res,next){

	if( req.session.user.uID == req.body.userID){
		req.session.user =  null;
		console.log(req.session.user);
		return res.json({
			'code':350,
			'phase':'logout success'
		});
	}else{
		return res.json({
			'code':351,
			'phase': 'logout failed'
		}); 
	}
	
}


