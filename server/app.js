import express from 'express';
import path from "path";
import cookieParser from "cookie-parser";
import bodyParser from "body-parser";
import nunjucks from "nunjucks";

import dispatcher from "./sockets/stores/dispatcher";

// import data from configs
import { serverPort, appData } from '../etc/config.json';


import * as db from './utils/DBUtils';
import * as ct from './utils/cryptHash';
// Initialization of express application
const app = express();

// main function sockets
import { initSocket } from "./sockets";

// learner router
const routeLearner = express.Router();

// connect to DB (mongoDB)
db.setUpConnection();

// use static files
app.use('/cssFiles', express["static"](path.resolve(__dirname, '../Public/media/stylesheets')));
app.use('/libsFiles', express["static"](path.resolve(__dirname, '../Public/media/libs')));
app.use('/jsFiles', express["static"](path.resolve(__dirname, '../Public/media/scripts')));
app.use('/imgFiles', express["static"](path.resolve(__dirname, '../Public/media/img')));
app.use('/fontsFiles', express["static"](path.resolve(__dirname, '../Public/media/fonts')));

app.use( cookieParser() );
app.use( bodyParser.json() );
app.use(bodyParser.urlencoded({
  extended: true
}));

// configs nunjucks
nunjucks.configure("./Public/pages", {
	autoscape: true,
	express: app
});

// index
app.get('/', (req, res) => {
	res.render("main/index.html", { date: new Date(), apps: ['chat', "test", "quest"] });
});

// main learner routes
app.use("/learner", routeLearner);

routeLearner.get("/", (req, res) => {
	// Здесь будет рендериться шаблон входа для ученика - ~/__projects/web/learnerIndexPage
	res.render("learner/index.html", { stateApp: {chat: appData.chat.state ? "работает" : "не работает" , test: appData.test.state ? "работает" : "не работает"} });
});

dispatcher.register((action) => {
	console.log(action)
	switch(action.type){
		case "CHANGE_APP_STATE": {
			switch(action.app){
				case "chat": {
					appData.chat.state = action.payload;
				};break;
				case "test": {
					appData.test.state = action.payload;
				};break;
			}
		}
	}
});

routeLearner.get("/chat", (req, res) => {
	if(appData.chat.state){
		res.render("learner/chat.html", {});
	}
	else {
		res.render("main/closed.html", {title: "ChatApp - Closed", massage: "Доступ закрыт)"});
	}
});

routeLearner.get("/test", (req, res) => {
	// db.listTests().then((data) => {
	// 	res.send(data);
	// });
	if(appData.test.state){
		res.render("learner/test.html", {});
	}
	else {
		res.render("main/closed.html", {title: "TestApp - Closed", massage: "Доступ закрыт)"});
	}
});

// Admin routes
app.get("/adminlogin", (req, res) => {
	res.render("admin/login.html", {});
});
app.post("/admin", (req, res) => {
	let hash = ct.encryptLogPass(req.body.login, req.body.password);
	db.listUsers().then((data) => {
		let t = false;
		data.map((i, j) => {
			if(i.hash == hash){
				t = true;
				res.cookie("secret", `${ct.encryptHash("TheBestFriends", "Osman")}`);
				res.cookie("key", "Osman");
				res.redirect("/admin");
			}
		})
		if(!t) {
			res.redirect("/adminlogin?errnum=1");
		} 
			
	});
});

app.get("/admin", (req, res) => {
	// void(0) == null		 //true
	// void(0) == udefined //true
	if(req.cookies.secret != void(0)){
		try{
			if("TheBestFriends" == ct.decryptHash(req.cookies.secret, req.cookies.key)){
				res.render("admin/index.html", {});
			}
			else{
				res.clearCookie("secret");
				res.clearCookie("key");
				res.redirect("/adminlogin");
			}
				
		}catch(err){
			res.clearCookie("secret");
			res.clearCookie("key");
			res.redirect("/adminlogin");
		}
	}
	else{
		res.redirect("/adminlogin");
	}
});	

app.get("/logout", (req, res) => {
	res.clearCookie("secret");
	res.clearCookie("key");
	res.redirect("/adminlogin");
});


// error 404
app.get("/*", (req, res) => {
	res.send("error 404");
});


const server = app.listen(serverPort, function() {
	console.log(`Server is up and running on port ${serverPort}`);
});

// init socket'a
initSocket(server, db);