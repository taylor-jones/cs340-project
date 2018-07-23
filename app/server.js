/* 
 *Author: Andrew Soback, Taylor Jones
 *CS340
 *Meal Wheel Database Class Project
 */

var express = require("express");
var app = express();

app.set('port', 31001);
app.use(express.static('public'));

//app.set('view engine', 'ejs');
//app.engine('html', require('ejs').renderFile);

//app.set('view engine', 'ejs');
//app.engine('html', require('ejs').renderFile);

app.get('/', function(req, res){
  res.redirect('/index.html');
});

/*
app.post('/', function(req, res){
 res.redirect('index.html');
});
*/

app.use(function(req, res){
	res.status(404);
	res.redirect('/404.html');
});

app.listen(app.get('port'), function(){
	console.log('Express started on http://localhost:' + app.get('port') + '; press Ctrl-C to terminate.');
});