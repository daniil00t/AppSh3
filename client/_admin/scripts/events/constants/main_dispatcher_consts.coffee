keyMirror = require "keymirror"

###
	Здесь хранятся все константы, использованные в main_dispatcher'e
	...
	dispatcher.register (action)=>
		switch action.type
			when __type__
				...some_code
	__type__ 
###

module.exports = keyMirror({
	# Global - App
	CHANGE_APP_STATE: null,

	# Admin_panel:
	# Chat
	INIT_CHAT_HELLO: null,
	CHANGE_CHAT_HELLO: null,
	
	# test
	INIT_LOAD_USER_TO_TESTS_COMPONENT: null,
	DELETE_TEST: null,

	# work tests
	SAVE_TEST: true,
	ACTIVE_TEST: true,
	
	# ETC
	NOTIFICATION: null
})