React = require 'react'
io = require "socket.io-client"
socket = io('')
crypto = require('crypto')
ee = require "./ee"
Panel = require "./components/admin_panel"

App = React.createClass
	displayName: 'App'
	getInitialState: ->
		numErr: -1
		adminOnline: false
		auth: no
		preloader: true

		# Chat states
		chatHello: ""
	handleLogin: ->
		socket.emit "adminLogin",  {login: document.getElementById("login1").value, password: document.getElementById("password1").value}
	componentWillMount: ->
		socket.on "StartAdmin", (data)=>
			# @setState adminOnline: data.online
			@setState preloader: false
		socket.on "adminLoginSuccess", (data)=>
			@setState auth: true
			@setState adminOnline: true
			console.log "Auth"

		socket.on "YOUADMIN", (data)=>
			@setState auth: data.type
			@setState adminOnline: data.type
			setTimeout (=>
				@setState preloader: false
			), 300

		socket.on "err", (data)=>
			@setState numErr: data.num
		ee.on "logoutAdmin", (data)->
			socket.emit "logoutAdmin", type: on
			window.location.replace("http://#{window.location.host}/admin")
		ee.on "loadUsers", (data)->
			if data.status == "load"
				socket.emit "loadUsers", status: "load"
		socket.on "loadUsers", (data)->
			if data.status == "sending"
				ee.emit "loadUsers", data: data.data, status: "sending"
		
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
			socket.emit "importD"
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
				{
					if !@state.adminOnline
						<div>
							<span style={color: "red"}>{if @state.numErr == 1 then "login or password are incorrect!"}</span>
							<div className="wrp-login">
								<h1>Admin Login</h1>
								<div id="login"><input type="text" id="login1" placeholder="login"/></div>
								<div id="pass"><input type="password" id="password1" placeholder="password"/></div>
								<button onClick={@handleLogin}>Login</button>
							</div>
						</div>
					else
						console.log @state.auth
						if @state.auth
							<Panel data={{chat: {chatHello: @state.chatHello}}}/>
						else
							<span>{@state.numErr}</span>
				}
			</div>
		</div>

module.exports = App