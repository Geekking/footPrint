
/**
 * Module dependencies.
 */

var express = require('express');
var routes = require('./routes');
var user = require('./routes/user');
var upload = require('./routes/upload');
var http = require('http');
var path = require('path');
var settings = require('./settings');
var MongoStore = require('connect-mongo')(express);
var app = express();

// all environments

app.use(express.cookieParser(settings.cookieSecret));
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.bodyParser());
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

app.post('/uploadFP', routes.checkLogin);
app.post('/uploadFP', function (req, res, next) {
  console.log(req.files);
  res.send('upload Success!');
});
app.post('/registe',routes.registe);
app.post('/login',routes.logIn);

app.post('/logout',routes.checkLogin);
app.post('/logout',routes.logOut);

app.listen(3000);
