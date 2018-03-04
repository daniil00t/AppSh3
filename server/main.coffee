express = require('express')
app = express()
server = require('http').Server(app)
io = require('socket.io')(server)
path = require "path"
fs = require('fs')
URL = require('url')

Store = require "./store"

app.use('/cssFiles', express["static"](path.resolve __dirname, '../Public/stylesheets'))
app.use('/jsFiles', express["static"](path.resolve __dirname, '../build/scripts'))

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
	res.sendfile path.resolve __dirname, "../Public/admin.html"

######

app.get "/learner", (req, res)->
	res.sendfile path.resolve __dirname, "../build/index.html" 

######

app.get "/*", (req, res)->
	res.send "error 404"


store = new Store
j = 0
io.on 'connection', (socket)->
	urlpath = URL.parse(socket.handshake.headers.referer).path.split("/")[1]

	if urlpath is "learner"
		###Learner function and methods...###
		id = socket.id
		console.log "connected user, id: #{id}"
		store.addNewClient 
			id: id
			ip: socket.handshake.address
			type: "learner"
			privileges: 3
		socket.emit 'connected', { id: id }

		### Main methods learner ###


		socket.on "closed", (data)->
			console.log "disconnect user, id: #{data.id}"
			store.deleteClient data.id
			console.log store
	else
		if urlpath is "admin"
			###Admin funcs and methods...###
			socket.on "adminLogin", (data)->
				_data = data
				# data -> login, password
				_data.ip = socket.handshake.address
				if _data.login == "root" and _data.password == "adminsh3"
					store.addNewClient 
						ip: _data.ip
						type: "admin"
						login: true
						privileges: 10
					console.log "Login! #{_data.ip} -> admin"
				else
					console.log "wrong!Login or password incorrected!"
					socket.emit "errAdminLogin", {type: 1}
		else
			console.log "/"

	# socket.on "sendMassage", (data)->
	# 	store.addContent data.id, data.massage
	# 	console.log store.getClient data.id
	# 	appendToFile "./db.log", "#{data.id}: #{data.massage}\n"
	# 	socket.broadcast.emit "news", {id: data.id, data: data.massage}
	# 	socket.emit "news", {id: data.id, data: data.massage}
	# 	# socket.broadcast.send data.massage
