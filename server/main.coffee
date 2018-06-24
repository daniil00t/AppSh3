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

app.use('/imgFiles', express["static"](path.resolve __dirname, '../Public/img'))

# app.use('/filesForData', express["static"](path.resolve __dirname, '../docs'))
# app.use('/filesETC', express["static"](path.resolve __dirname, '../Public/etc'))

# fs.writeFile "db.log", "", (err)->
# 	if err then throw err
# appendToFile = (filename, data)->
# 	fs.appendFile filename, data, (err)->
#   	if err then throw err

server.listen(3000)
console.log "works in 3000 port"

######
# App require index.html for tamplate
app.set('socket', io)

app.get '/', (req, res)->
  res.sendfile path.resolve __dirname, "../Public/index.html"

######

app.get "/admin", (req, res)->
	# ip = req.headers['x-forwarded-for'] or req.connection.remoteAddress or req.socket.remoteAddress or (if req.connection.socket then req.connection.socket.remoteAddress else null)
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
			ip = socket.handshake.address
			ban = false
			for i in store.getUsersBan()
				if i is ip
					ban = true
					socket.emit "UserInBan", type: true

			if ban is false
				DB.setUpConnection()
				Test.getData(TestSchema).then (data)->
					_data = filterClientTest data
					socket.emit "getDataTest", _data
				socket.on "sendDataTest", (data)=>
					console.log data
				id = socket.id
				console.log "connected user, id: #{id}"
				store.addNewClient 
					id: id
					ip: socket.handshake.address
					type: "learner"
					privileges: 3
					app: "test"
				socket.emit 'connected', id: id, ip: ip
				# console.log store.getClients()
			
				socket.on "closed", (data)->
					console.log "disconnect user, id: #{data.id}"
					store.deleteClient data.id



				socket.on "setNameForTest", (data)->
					console.log "up"
					store.updateClient(data.id, {fname: data.firstname_user})
					store.updateClient(data.id, {lname: data.lastname_user})

			# Test.updateTest TestSchema, "5ac8eaec68352c16604b478a", { data: [{
			# 	anses: ["63<sub>10</sub> · 4<sub>10</sub>","F8<sub>16</sub>+1<sub>10</sub>","333<sub>8</sub>","11100111<sub>2</sub>"],
			# 	trueanses:[1],
			# 	_id:"5ab13b053ad35c0284233fb2",
			# 	type:"defQ",
			# 	num:0,
			# 	question:"Даны 4 числа, они записаны с использованием различных систем счисления. Укажите среди этих чисел то, в двоичной записи которого содержится ровно 6 единиц. Если таких чисел несколько, укажите наибольшее из них.",
			# 	__v:0,
			# 	score:1
			# }]}
			# Test.updateTestAll TestSchema, { time: 10 }
			# test.addTest()

			# setTimeout (->
			# 	Test.addTest(TestSchema, {
			# 		type: "inpQ",
			# 		num: 3,
			# 		question: "Как тебя зовут?",
			# 		score: 2,
			# 		trueanses: ["Daniil"]
			# 	})
			# ),2000
			
		else
			console.log "/"
			route_sock.admin(socket, store)
			socket.on "exportDBonFile", (data)->
				DB.setUpConnection()
				Test.getTests(TestSchema).then (data)->
					fs.writeFile "./docs/db_test.json", JSON.stringify(data), "utf-8", (err)=>
						if err then throw err
						console.log "saved file"
						socket.emit "sendPathExportFileDB", {path: "/FilesForData/db_test.json"}
			###Delete###

			###endDelete###
	# socket.on "sendMassage", (data)->
	# 	store.addContent data.id, data.massage
	# 	console.log store.getClient data.id
	# 	appendToFile "./db.log", "#{data.id}: #{data.massage}\n"
	# 	socket.broadcast.emit "news", {id: data.id, data: data.massage}
	# 	socket.emit "news", {id: data.id, data: data.massage}
	# 	# socket.broadcast.send data.massage

