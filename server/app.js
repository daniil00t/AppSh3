import express from 'express';
import path from "path";
import cookieParser from "cookie-parser";
import bodyParser from "body-parser";
import nunjucks from "nunjucks";


// import data from configs
import { serverPort } from '../etc/config.json';

import * as db from './utils/DBUtils';
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

app.use(cookieParser());
app.use( bodyParser.json() );
app.use(bodyParser.urlencoded({
  extended: true
}));

nunjucks.configure("./Public/pages", {
	autoscape: true,
	express: app
});

// index
app.get('/', (req, res) => {
	res.render("index.html", { date: new Date() });
});

// main learner routes
app.use("/learner", routeLearner);

routeLearner.get("/", (req, res) => {
	res.send("<a href='/learner/chat'>chat</a><br /><a href='/learner/test'>test</a>");
});

routeLearner.get("/chat", (req, res) => {
	res.render("learner/chat.html", {});
});

routeLearner.get("/test", (req, res) => {
	// db.listTests().then((data) => {
	// 	res.send(data);
	// });
	res.render("learner/test.html", {});
});

// Admin routes

app.get("/admin", (req, res) => {
	res.sendfile(path.resolve(__dirname, "../Public/pages/admin/login.html"));
	console.log(req.cookies);
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