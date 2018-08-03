React = require 'react'
io = require "socket.io-client"
socket = io('')
URL = require "url"
crypto = require('crypto')
ee = require "./ee"
Panel = require "./components/admin_panel"

App = React.createClass
	displayName: 'App'
	getInitialState: ->
		numErr: -1
		users: []
		users_anses: []
		data_true_anses: []
		# Chat states
		chatHello: ""
	updateScoreUsers: (data)->
		score = 0
		arr = @state.users
		lengthVariantTests = 0
		@state.users.map (i, j) => 
			data.map (k, l) =>
				if i.id == k.id
					# начинаем проверку
					k.data.map (q, w)=>
						@state.data_true_anses[i.variant - 1].data.map (r, t)=>
							console.log q, r
							if q.no == r.no
								if q.value == r.value[0]
									score++

					lengthVariantTests = @state.data_true_anses[i.variant - 1].data.length
					arr[j].score = score
					console.log "score: #{score}, lengthVariantTests: #{lengthVariantTests}"
					arr[j].points = Math.round(score / lengthVariantTests * 100)
					score = 0
		@setState users: arr

	componentWillMount: ->
		socket.on "init", (data)=>
			switch data.type
				when "users"
					@setState users: data.data
				when "data_users"
					@setState users_anses: data.data
					console.log data.data
					
				when "data_true_anses"
					@setState data_true_anses: data.data
					@updateScoreUsers(@state.users_anses)
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
		
		ee.on "deleteUserAndMassage_ee", (data)=>
			socket.emit "deleteUserAndMassage", data

		### _ Chat _ ###

		socket.on "getLoadData@soc", (data)=>
			@setState chatHello: data.chatHello

		ee.on "changeHello@ee", (data)=>
			socket.emit "changeHelloChat", cnt: data.cnt
		# socket.on "errorSrv@soc", (data)=>
		# 	alert "TypeError: #{data.type}. #{data.err}"

		### _ DB _ ###
		ee.on "importDB@ee", (data)=>
			socket.emit "importDB@soc", type: data.type
	render: ->
		<div className="wrp_admin">
			<div className="preloader" style={display: if !@state.preloader then "none"}>
				<div className="cssload-thecube">
					<div className="cssload-cube cssload-c1"></div>
					<div className="cssload-cube cssload-c2"></div>
					<div className="cssload-cube cssload-c4"></div>
					<div className="cssload-cube cssload-c3"></div>
				</div>
			</div>
			<div className="container-fluid">
				<Panel data={ { chat: {chatHello: @state.chatHello}, users: {data: @state.users}} }/>
			</div>
		</div>

module.exports = App