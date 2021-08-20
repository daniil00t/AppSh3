React = require 'react'
io = require "socket.io-client"
socket = io('')
URL = require "url"
crypto = require('crypto')
ee = require "./ee"
Panel = require "./components/admin_panel"

###
	Events
###

# main_socket_consts == MSC
MSC = require "./events/constants/main_socket_consts"
dispatcher = require "./events/dispatchers/main_dispatcher"

main_actions = require "./actions/app_actions"

# Etc components
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
		# main action
		main_actions socket, @


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