/*
 * Module dependencies.
 */

var express = require('express');
var routes = require('./routes');
var user = require('./routes/user');
var upload = require('./routes/upload');
var friends = require('./routes/friends');
var around = require('./routes/around');
var comment = require('./routes/comment');
var http = require('http');
var path = require('path');
var settings = require('./settings');
var MongoStore = require('connect-mongo')(express);
var app = express();
// all environments

app.use(express.cookieParser(settings.cookieSecret));
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.bodyParser({uploadDir: "./public/upload"}));
//app.use(express.urlencoded());
//app.use(express.json());
//app.use(form);
app.use(express.session({
	secret: settings.cookieSecret,
	store: new MongoStore({
		db: settings.sessionDb
	})
}));
app.use(app.router);

app.get('/',function(req,res,next){
	res.json({'he':'test'});
});

app.get('file/:filepath',routes.checkLogin);
app.get('/file/:filepath',function(req,res){
	var filepath = req.params.filepath;
	console.log('./public/upload/',filepath);
	res.sendfile('./public/upload/'+filepath);
});

app.post('/refreshFP',routes.checkLogin);
app.post('/refreshFP',upload.refreshFP);

app.post('/postFP', routes.checkLogin);
app.post('/postFP', upload.newFP);

app.post('/findUser',friends.findUser);

app.post('/getFriends',routes.checkLogin);
app.post('/getFriends',friends.getFriends);

app.post('/addFriend',routes.checkLogin);
app.post('/addFriend' ,friends.addUser);

app.post('/getFriends',routes.checkLogin);
app.post('/getFriends',friends.getFriends);

app.post('/registe',routes.registe);
app.post('/login',routes.logIn);

app.post('/logout',routes.checkLogin);
app.post('/logout',routes.logOut);

app.post('/searchNearFP',routes.checkLogin);
app.post('/searchNearFP',around.searchNearFP);

app.post('/commentOnFP',routes.checkLogin);
app.post('/commentOnFP',comment.commentOnFP);

app.post('/getCommentOfFP',routes.checkLogin);
app.post('/getCommentOfFP',comment.getCommentOfFP);

app.post('/getPersonInfo',routes.checkLogin);
app.post('/getPersonInfo', user.getPersonInfo);

app.listen(3000);
