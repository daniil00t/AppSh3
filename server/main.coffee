express = require('express')
app = express()
server = require('http').Server(app)
io = require('socket.io')(server)
path = require "path"
fs = require('fs')
URL = require('url')
crypto = require('crypto')
session = require "express-session"
cookieParser = require "cookie-parser"
bodyParser = require "body-parser"

# redirect = require("express-redirect")
# redirect(app)
route_sock = require "./route_sock"
ee = require "./ee"

Test = require "./modules/test.learner.module"
TestSchema = require "./utils/schema_test"

UsersSchema = require "./utils/schema_user"
Users = require "./modules/test.learner.module"

DB = require "./utils/db"



Store_users = require "./users.store"

app.use('/cssFiles', express["static"](path.resolve __dirname, '../Public/stylesheets'))
app.use('/libsFiles', express["static"](path.resolve __dirname, '../Public/libs'))
app.use('/jsFiles', express["static"](path.resolve __dirname, '../Public/scripts'))

app.use('/imgFiles', express["static"](path.resolve __dirname, '../Public/img'))

app.use(cookieParser())
app.use( bodyParser.json() )
app.use(bodyParser.urlencoded({
  extended: true
}))
# app.use(express.cookieParser())
# app.use(session({
# 	secret: "Hello"
# }))

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
encryptHash = (data, key)->
	cipher = crypto.createCipher('aes-256-cbc', key)
	crypted = cipher.update(data, 'utf-8', 'hex')
	crypted += cipher.final('hex')
	return crypted


decryptHash = (data, key)->
	decipher = crypto.createDecipher('aes-256-cbc', key)
	decrypted = decipher.update(data, 'hex', 'utf-8')
	decrypted += decipher.final('utf-8')
	return decrypted


# encryptLogPass - функция, умеющая кодировать логин и пароль в хэш(ключ используется - Осман)
encryptLogPass = (login, pass)->
	l1 = if login.length < 9 then "0#{login.length}" else login.length
	p1 = if pass.length < 9 then "0#{pass.length}" else pass.length
	key = "Osman" + l1 + p1
	encryptHash(login + pass, key) + l1 + p1


# decryptLogPass - функция, умеющая декодировать хэш в обычный объкт, сост. из логина и пароля
decryptLogPass = (hash)->
	_hash = hash.substr(0, hash.length-4)
	_nums =  hash.substr(hash.length-4, hash.length)

	n1 = Number _nums.substr(0, 2)
	n2 = Number _nums.substr(2, 4)

	key = "Osman" + _nums
	{str: decryptHash(_hash, key), login: decryptHash(_hash, key).substr(0, n1), pass: decryptHash(_hash, key).substr(n1, n1+n2)}


app.get "/adminlogin", (req, res)->
	res.sendfile path.resolve __dirname, "../Public/admin/login.html"




DB.setUpConnection()
app.post "/admin", (req, res)->
	hash = encryptLogPass(req.body.login, req.body.password)
	t = 0
	Users.getData(UsersSchema).then (__data)=>
		t = no
		for i in __data
			console.log i
			if i.hash == hash
				t = on
				res.cookie("secret", "#{encryptHash("TheBestFriends", "Osman")}")
				res.cookie("key", "Osman")
				res.redirect "/admin"
				break
		if !t then res.redirect "/adminlogin?errnum=1"

app.get "/admin", (req, res)->
	# ip = req.headers['x-forwarded-for'] or req.connection.remoteAddress or req.socket.remoteAddress or (if req.connection.socket then req.connection.socket.remoteAddress else null)
	if req.cookies.secret?
		try
			if "TheBestFriends" == decryptHash(req.cookies.secret, req.cookies.key)
				res.sendfile path.resolve __dirname, "../Public/admin/index.html"
			else
				res.clearCookie("secret")
				res.clearCookie("key")
				res.redirect "/adminlogin"
		catch
			res.clearCookie("secret",)
			res.clearCookie("key")
			res.redirect "/adminlogin"
	else
		res.redirect "/adminlogin"

app.get "/logout", (req, res)->
	res.clearCookie("secret")
	res.clearCookie("key")
	console.log req.cookies
	#res.send "logout..."
	res.redirect "/adminlogin"
######

app.get "/learner/chat", (req, res)->
	res.sendfile path.resolve __dirname, "../Public/learner/chat.html"

app.get "/learner", (req, res)->
	res.sendfile path.resolve __dirname, "../Public/learner/index.html"

app.get "/learner/test", (req, res)->
	res.sendfile path.resolve __dirname, "../Public/learner/test.html"

# app.get "/inc", (req, res)->
# 	console.log req.cookies.admin
# 	res.setHeader("Set-Cookie", "admin=10")
# 	# res.end() 
# 	res.send "hello cookie!"
#app.get "/importdb", (req, res)->
#	res.send "import"


app.get "/exportdb", (req, res)->
	# Сборка файла
	#console.log URL.parse(req.url).query
	query = JSON.parse('{"' + decodeURI(URL.parse(req.url).query.replace(/&/g, "\",\"").replace(/=/g,"\":\"")) + '"}')
	if query.type?
		switch query.type
			when "users"
				res.send "download users db"
			when "tests"
				res.send "download tests db"
			else
				res.send "err"
	pathfile = "./etc/users.db"
	# Скачивание файла
	#res.download path.resolve __dirname, pathfile


### _ Error 404 _ ###

app.get "/*", (req, res)->
	res.send "error 404"


filterClientTest = (arr)->
	_arr = arr
	for i, j in _arr
		_arr[j].trueanses = ""
	_arr



store_users = new Store_users
io.on 'connection', (socket)->
	urlpath = URL.parse(socket.handshake.headers.referer).path
	###Learner function and methods...###
	switch urlpath
		when "/learner/chat"
			route_sock.learner_chat(socket, store_users)
		when "/admin"
			route_sock.admin(socket, store_users)
		when "/adminlogin"
			route_sock.admin(socket, store_users)
		when "/learner/test"
			ip = socket.handshake.address
			ban = false
			for i in store_users.getUsersBan()
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
				store_users.addNewClient 
					id: id
					ip: socket.handshake.address
					type: "learner"
					privileges: 3
					app: "test"
				socket.emit 'connected', id: id, ip: ip
				# console.log store_users.getClients()
			
				socket.on "closed", (data)->
					console.log "disconnect user, id: #{data.id}"
					store_users.deleteClient data.id



				socket.on "setNameForTest", (data)->
					console.log "up"
					store_users.updateClient(data.id, {fname: data.firstname_user})
					store_users.updateClient(data.id, {lname: data.lastname_user})

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
			# route_sock.admin(socket, store_users)
			# socket.on "exportDBonFile", (data)->
			# 	DB.setUpConnection()
			# 	Test.getTests(TestSchema).then (data)->
			# 		fs.writeFile "./docs/db_test.json", JSON.stringify(data), "utf-8", (err)=>
			# 			if err then throw err
			# 			console.log "saved file"
			# 			socket.emit "sendPathExportFileDB", {path: "/FilesForData/db_test.json"}
	# socket.on "sendMassage", (data)->
	# 	store_users.addContent data.id, data.massage
	# 	console.log store_users.getClient data.id
	# 	appendToFile "./db.log", "#{data.id}: #{data.massage}\n"
	# 	socket.broadcast.emit "news", {id: data.id, data: data.massage}
	# 	socket.emit "news", {id: data.id, data: data.massage}
	# 	# socket.broadcast.send data.massage

