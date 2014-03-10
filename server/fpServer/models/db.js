var setting = require('../settings');
var mysql = require('mysql');

module.exports = mysql.createConnection({
	host: setting.host,
	user: setting.user,
	password: setting.password,
	database: setting.db,
	port: setting.defaultPort,
});

