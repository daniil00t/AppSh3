keyMirror = require "keymirror"

###
	Здесь хранятся все константы, использованные в main_dispatcher'e
	...
	socket.on __type__, (data)=>
			...some_code
	__type__ 
###

module.exports = keyMirror({
	# socket.on
	
	# App
	INIT: null,

	# users
	CONNECT_USER: null,
	DISCONNECT_USER: null,
	UPDATE_USER: null,

	UPDATE_ANSWER_USER: null
})