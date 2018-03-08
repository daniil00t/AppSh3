React = require 'react'
io = require "socket.io-client"
socket = io('http://192.168.100.12:3000')

config = {}

socket.on "connected", (data)->
	console.log data
	config["id"] = data.id
	config["ip"] = data.ip
window.onbeforeunload = ->
	socket.emit "closed", {id: config.id}

App = React.createClass
	displayName: 'App'
	getInitialState: ->
		id: config.id
		ip: config.ip
		errAdmin: 0
	# handleLogin: ->
	# 	socket.emit "adminLogin", {login: document.getElementById("login").value, password: document.getElementById("password").value}
	componentWillMount: ->
		socket.on "connected", (data)=>
			@setState id: data.id, ip: data.ip

		socket.on "errAdminLogin", (data)=>
			@setState errAdmin: data.type
	render: ->
		<div className="container">
			<span>id: {config.id}</span><br />
			<span>ip: {config.ip}</span>
		</div>

module.exports = App