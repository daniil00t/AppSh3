main_dispatcher = require "../events/dispatchers/main_dispatcher"
# MC = MSC + MDC
MC = Object.assign require("../events/constants/main_socket_consts"), require("../events/constants/main_dispatcher_consts")

nothing = ->
	```
	let a = 10;
	delete a;
	```

module.exports = (socket, self)->
	socket.on MC.INIT, (data)=>
		switch data.type
			# chat
			when "users"
				self.setState users: data.data
				main_dispatcher.dispatch
					type: MC.INIT_LOAD_USER_TO_TESTS_COMPONENT
					payload: data.data
			# test
			when "data_users"
				self.setState users_anses: data.data
				console.log data.data
			when "data_true_anses"
				self.setState data_true_anses: data.data
				self.updateScoreUsers(self.state.users_anses)
			when "data_tests"
				self.setState data_tests: data.data
			when "activeTest"
				main_dispatcher.dispatch
					type: "GET_ACTIVE_TEST",
					payload: data.data

			# chat
			when "chat_hello"
				main_dispatcher.dispatch
					type: MC.INIT_CHAT_HELLO
					payload: data.data
				self.setState chatHello: data.data
			else
				do nothing

	socket.on MC.CONNECT_USER, (data)=>
		arr = self.state.users
		arr.push data.payload
		self.setState users: arr

	socket.on MC.DISCONNECT_USER, (data)=>
		arr = self.state.users
		arr.map (i, j)=>
			if i.id == data.payload
				arr.splice j, 1
		self.setState users: arr

	socket.on MC.UPDATE_USER, (data)=>
		console.log data.payload
		arr = self.state.users
		for i, j in arr
			if i.id == data.payload.id
				for key, value of data.payload.data
					arr[j][key] = value
		self.setState users: arr



	socket.on MC.UPDATE_ANSWER_USER, (data)=>
		self.setState users_anses: data.payload
		self.updateScoreUsers(data.payload)
	
	main_dispatcher.register (action)=>
		switch action.type
			when MC.CHANGE_CHAT_HELLO
				self.setState chatHello: action.payload
				socket.emit "_CHANGE", type: action.type, data: action.payload
			when MC.CHANGE_APP_STATE
				socket.emit "_CHANGE", type: action.type, app: action.app, payload: action.payload
			
			# TEST
			when MC.SAVE_TEST
				socket.emit MC.SAVE_TEST, action
			when MC.ACTIVE_TEST
				socket.emit MC.ACTIVE_TEST, action


			# etc
			when MC.NOTIFICATION
				self.setState nf_visible: true, nf_all_data: {data: action.payload.data, type: action.payload.type}
			else
				do nothing