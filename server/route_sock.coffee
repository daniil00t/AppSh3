crypto = require('crypto')
ee = require "./ee"

DB = require "./utils/db"
UsersSchema = require "./utils/schema_user"
Users = require "./modules/test.learner.module"

Chat_store = require "./chat.store"

chat_store = new Chat_store("Привет! Ты попал в чат! Пользуйся чем хочешь, но не сквернословь!", 10)

learner_chat = (socket, store)->

	# Registr new client
	id = socket.id
	ip = socket.handshake.address
	console.log "connected user, id: #{id}, ip: #{ip}"
	store.addNewClient 
		id: id
		ip: ip
		type: "learner"
		app: "chat"
	socket.emit 'connected', id: id, ip: ip, hello: chat_store.getHello()


	### Main methods learner ###

	### _ SOCKET LESTENERS _ ###

	# Lesteners
	socket.on "changeNameUsr@soc", (data)->
		# Проверка имени на совподаемость
		console.log data
		nameOnline = no
		for i in store.getClients()
			if i.name == data.name
				nameOnline = on
				break
		if !nameOnline
			store.updateClient data.id, {name: data.name}
		else
			socket.emit "errorUsr@soc", {nameError: "name is holded", noError: 1, descError: "Вы использовали уже занятое имя другим пользователем.", helpError: "Пожалуйста, придумайте другое имя пользователя."}
			console.log "name is holded"

	socket.on "changePathImgUsr@soc", (data)->
		store.updateClient data.id, {path: data.path}

	socket.on "addMassageToChat@soc", (_data)->
		# console.log "id: #{data.id} | text: #{data.massage}"
		console.log _data
		socket.broadcast.emit "newMassageToChatUsers", {id: _data.id, nameUsr: _data.nameUsr, pathAva: _data.pathAva, massage: _data.massage}
		# socket.emit "newMassageToChatUsers", {id: _data.id, nameUsr: _data.nameUsr, pathAva: _data.pathAva, massage: _data.massage}

	socket.on "disconnect", (e) =>
		id = socket.id
		console.log "disconnect user, id: #{id}"
		store.deleteClient id

	### _ EventEmmiter _ ###

	# events from stores
	ee.on "changeHello_chat@ee", (data)->
		socket.emit "changeHello@soc", cnt: data.cnt
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
	adminOnline = store.getAdminOnline()
	ip = socket.handshake.address

	# console.log adminOnline
	DB.setUpConnection()

	socket.on "adminLogin@soc", (data)=>
		console.log data
		Users.getData(UsersSchema).then (__data)=>
			for i, j in __data
				# console.log i
				if i.privelegs == "admin" and i.hash == encryptLogPass(data.login, data.password)
					ee.emit "adminLogin@ee", type: true
					# res.setHeader("Set-Cookie", ["admin=login", "hash=#{i.hash}"])
					console.log "login!"
					socket.emit "doneLoginAdmin@soc", str: "hash=#{i.hash}"
				else
					# ERROR
					# console.log "error login"
					# break

	### _ Chat _ ###

	# Lesteners
	socket.on "changeHelloChat", (data)=>
		chat_store.changeHello data.cnt

	# Outputs
	socket.emit "getLoadData@soc", {chatHello: chat_store.getHello()}

	### _ DB _ ###

	pathfile = "./etc/users.db"
	


module.exports = {learner_chat: learner_chat, admin: admin}