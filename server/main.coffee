express = require('express')
app = express()
server = require('http').Server(app)
io = require('socket.io')(server)
path = require "path"
fs = require('fs')
URL = require('url')

# redirect = require("express-redirect")
# redirect(app)
route_sock = require "./route_sock"
ee = require "./ee"
Test = require "./modules/test.learner.module"
TestSchema = require "./utils/schema_test"
DB = require "./utils/db"



Store = require "./store"

app.use('/cssFiles', express["static"](path.resolve __dirname, '../Public/stylesheets'))
app.use('/libsFiles', express["static"](path.resolve __dirname, '../Public/libs'))
app.use('/jsFiles', express["static"](path.resolve __dirname, '../Public/scripts'))

fs.writeFile "db.log", "", (err)->
	if err then throw err
appendToFile = (filename, data)->
	fs.appendFile filename, data, (err)->
  	if err then throw err

server.listen(3000)
console.log "works in 3000 port"

######
# App require index.html for tamplate
app.set('socket', io)

app.get '/', (req, res)->
  res.sendfile path.resolve __dirname, "../Public/index.html"

######

app.get "/admin", (req, res)->
	ip = req.headers['x-forwarded-for'] or req.connection.remoteAddress or req.socket.remoteAddress or (if req.connection.socket then req.connection.socket.remoteAddress else null)
	res.sendfile path.resolve __dirname, "../Public/admin/index.html"

######

app.get "/learner/chat", (req, res)->
	res.sendfile path.resolve __dirname, "../Public/learner/chat.html"

app.get "/learner", (req, res)->
	res.sendfile path.resolve __dirname, "../Public/learner/index.html"

app.get "/learner/test", (req, res)->
	res.sendfile path.resolve __dirname, "../Public/learner/test.html"

######

app.get "/*", (req, res)->
	res.send "error 404"


filterClientTest = (arr)->
	_arr = arr
	for i, j in _arr
		_arr[j].trueanses = ""
	_arr



store = new Store
io.on 'connection', (socket)->
	urlpath = URL.parse(socket.handshake.headers.referer).path
	###Learner function and methods...###
	switch urlpath
		when "/learner/chat"
			route_sock.learner_chat(socket, store)
		when "/admin"
			route_sock.admin(socket, store)
		when "/learner/test"
			DB.setUpConnection()
			Test.getTests(TestSchema).then (data)->
				_data = filterClientTest data
				socket.emit "getDataTest", _data

			# Test.updateTest TestSchema, "5ab13bc6b1ebda12dcd3b60e", { anses: [
			# 	{firstItems: ["Admin", "You", "Like"], secondItems: ["Krasavchik", "Me", "Solnyshko"]}
			# ] }
			# test.addTest()
			# DB.addTest({
			# 	type: "defQ",
			# 	num: 0,
			# 	question: "Привет! Как у тебя дела?",
			# 	anses: [
			# 		["Норм, ну вообщем как всегда!", 0]
			# 		["Супер, потому что это работает!", 1]
			# 		["Как всегда", 0]
			# 		["Не знаю", 0]
			# 	]
			# })
		else
			console.log "/"
			###Delete###

			###endDelete###
	# socket.on "sendMassage", (data)->
	# 	store.addContent data.id, data.massage
	# 	console.log store.getClient data.id
	# 	appendToFile "./db.log", "#{data.id}: #{data.massage}\n"
	# 	socket.broadcast.emit "news", {id: data.id, data: data.massage}
	# 	socket.emit "news", {id: data.id, data: data.massage}
	# 	# socket.broadcast.send data.massage
