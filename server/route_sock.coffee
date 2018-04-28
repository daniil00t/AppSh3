crypto = require('crypto')
ee = require "./ee"

DB = require "./utils/db"
UsersSchema = require "./utils/schema_user"
Users = require "./modules/test.learner.module"

learner_chat = (socket, store)->
	id = socket.id
	console.log "connected user, id: #{id}"
	ip = socket.handshake.address
	store.addNewClient 
		id: id
		ip: socket.handshake.address
		type: "learner"
		privileges: 3
		app: "chat"
	socket.emit 'connected', id: id, ip: ip
	### Main methods learner ###
	socket.on "setNameLearner", (data)->
		nameOnline = no
		for i in store.getClients()
			if i.name == data.name
				nameOnline = on
				break
		if !nameOnline
			store.updateClient data.id, {name: data.name}
		else
			console.log "name is holded"
		console.log store.getClients()

	socket.on "newMassageToChat", (data)->
		console.log "id: #{data.id} | text: #{data.text}"

		socket.broadcast.emit "newMassageToChatUsers", {id: data.id, name: data.name, text: data.text}
		socket.emit "newMassageToChatUsers", {id: data.id, name: data.name, text: data.text}
		
		# appendToFile "./db.log", "#{data.id}: #{data.text}\n"

		###Closed Bar Browser method###
	socket.on "closed", (data)->
		console.log "disconnect user, id: #{data.id}"
		store.deleteClient data.id

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




admin = (socket, store)->
	###Admin funcs and methods...###

	# console.log decryptLogPass "f933e820c03a31975c7ccd788f5c5fda0607"
	# console.log decryptLogPass "fdae23efce058f58a26f061f52a81a730607"

	adminOnline = store.getAdminOnline()
	ip = socket.handshake.address

	# console.log adminOnline
	DB.setUpConnection()
	# Users.addData(UsersSchema, {hash: "fdae23efce058f58a26f061f52a81a730607", privelegs: "admin"})
	
	# Users.removeData UsersSchema, "5aca245acc5bd644deb63732"
	# Users.update UsersSchema, "5ada149c2b97af1ba80a87aa", { hash: "f933e820c03a31975c7ccd788f5c5fda0607"}

	
	# socket.emit "StartAdmin", {ip: ip, hash: encryptHash DATA.login, DATA.password}
	

	###Если админ не в сети###
	if !adminOnline
		socket.emit "StartAdmin", {online: no}
		# socket.emit "YOUADMIN", {type: true}
		socket.on "adminLogin", (data)->
			_data = data
			# data -> login, password
			_data.ip = socket.handshake.address
			Users.getData(UsersSchema).then (__data)=>
				log = false
				for i, j in __data
					if i.privelegs == "admin" and i.hash == encryptLogPass(data.login, data.password)
						store.setAdmin
							ip: _data.ip
							type: "admin"
							login: true
							privileges: 10
							hash: i.hash
						socket.emit "adminLoginSuccess", type: on
						console.log "Login! #{_data.ip} -> admin"
						console.log store.getAdmin()
						log = true
						break
			

					# ee.emit "redirectToAdmin", type: true
					# app.redirect "/admin", "/admin"
				if !log
					console.log "wrong!Login or password incorrected!"
					socket.emit "err", {num: 1}
		###Если админ в сети###			
	else
		console.log "admin online"
		if ip == store.getAdmin().ip
			socket.emit "YOUADMIN", {type: true}
		else
			socket.emit "err", {num: 2}
	socket.on "logoutAdmin", (data)->
		console.log "delete!"
		store.deleteAdmin()
	ee.on "changeUsers", (data)=>
		socket.emit "loadUsers", status: "sending", data: store.getClients()
	socket.on "loadUsers", (data)=>
		if data.status == "load"
			socket.emit "loadUsers", status: "sending", data: store.getClients()
			console.log "send"
	socket.on "deleteUserAndMassage", (data)->
		# ee.emit "deleteUser_toClient_ee", data
		console.log data
		store.addUserToBan data.ip
		console.log store.getUsersBan()
		socket.broadcast.emit "deleteUser_toClient", data
module.exports = {learner_chat: learner_chat, admin: admin}