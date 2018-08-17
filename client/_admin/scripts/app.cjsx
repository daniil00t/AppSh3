React = require 'react'
io = require "socket.io-client"
socket = io('')
URL = require "url"
crypto = require('crypto')
ee = require "./ee"
Panel = require "./components/admin_panel"

dispatcher = require "./components/dispatcher"
Notification = require "./components/comps/notification"

App = React.createClass
	displayName: 'App'
	getInitialState: ->
		numErr: -1
		users: []
		users_anses: []
		data_true_anses: []
		id_test_active: 0
		data_tests: []

		# Chat states
		chatHello: ""

		#etc
		nf_visible: false
		nf_all_data: {}
	updateScoreUsers: (data)->
		score = 0
		arr = @state.users
		lengthProblemsTests = 0
		@state.users.map (i, j) => 
			data.map (k, l) =>
				if i.id == k.id
					variant = i.variant - 1
					# начинаем проверку
					k.data.map (q, w)=>
						@state.data_true_anses[0].data[variant].map (r, t)=>
							console.log q, r
							if q.no == r.no
								if q.value == r.value[0]
									score += r.score

					lengthProblemsTests = @state.data_true_anses[0].data[variant].length
					arr[j].score = score
					arr[j].points = Math.round(score / lengthProblemsTests * 100)
					score = 0
		@setState users: arr

	componentWillMount: ->
		socket.on "init", (data)=>
			switch data.type
				# chat
				when "users"
					@setState users: data.data
					dispatcher.dispatch
						type: "INIT_LOAD_USER_TO_TESTS_COMPONENT"
						payload: data.data
				# test
				when "data_users"
					@setState users_anses: data.data
					console.log data.data
				when "data_true_anses"
					@setState data_true_anses: data.data
					@updateScoreUsers(@state.users_anses)
				when "data_tests"
					@setState data_tests: data.data
				# chat
				when "chat_hello"
					dispatcher.dispatch
						type: "INIT_CHAT_HELLO"
						payload: data.data
					@setState chatHello: data.data
				else
					console.log "no!"

		socket.on "CONNECT_USER", (data)=>
			arr = @state.users
			arr.push data.payload
			@setState users: arr

		socket.on "DISCONNECT_USER", (data)=>
			arr = @state.users
			arr.map (i, j)=>
				if i.id == data.payload
					arr.splice j, 1
			@setState users: arr
		socket.on "UPDATE_USER", (data)=>
			console.log data.payload
			arr = @state.users
			for i, j in arr
				if i.id == data.payload.id
					for key, value of data.payload.data
						arr[j][key] = value
			@setState users: arr



		socket.on "UPDATE_ANSWER_USER", (data)=>
			@setState users_anses: data.payload
			@updateScoreUsers(data.payload)
		
		dispatcher.register (action)=>
			switch action.type
				when "CHANGE_CHAT_HELLO"
					@setState chatHello: action.payload
					socket.emit "_CHANGE", type: action.type, data: action.payload
				when "CHANGE_APP_STATE"
					socket.emit "_CHANGE", type: action.type, app: action.app, payload: action.payload
				# TEST
				when "SAVE_TEST"
					console.log "main_", action
				# etc
				when "NOTIFICATION"
					@setState nf_visible: true, nf_all_data: {data: action.payload.data, type: action.payload.type}
				else
					console.log "problem..."


		### _ Chat _ ###



		ee.on "changeHello@ee", (data)=>
			socket.emit "changeHelloChat", cnt: data.cnt
		# socket.on "errorSrv@soc", (data)=>
		# 	alert "TypeError: #{data.type}. #{data.err}"

		### _ DB _ ###
		ee.on "importDB@ee", (data)=>
			socket.emit "importDB@soc", type: data.type
	render: ->
		<div className="wrp_admin">
			<Notification data={@state.nf_all_data.data} visible={@state.nf_visible} type={@state.nf_all_data.type}/>
			<div className="preloader" style={display: if !@state.preloader then "none"}>
				<div className="cssload-thecube">
					<div className="cssload-cube cssload-c1"></div>
					<div className="cssload-cube cssload-c2"></div>
					<div className="cssload-cube cssload-c4"></div>
					<div className="cssload-cube cssload-c3"></div>
				</div>
			</div>
			<div className="container-fluid">
				<Panel data={ { chat: {chatHello: @state.chatHello}, users: {data: @state.users}, tests: if @state.data_tests then @state.data_tests else [] } }/>
			</div>
		</div>

module.exports = App