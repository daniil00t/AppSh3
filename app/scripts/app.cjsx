React = require 'react'
io = require "socket.io-client"
socket = io('http://192.168.100.12:3000')

config = {}

socket.on "connected", (data)->
	config['id'] = data.id

window.onbeforeunload = ->
	socket.emit "closed", {id: config.id}

App = React.createClass
	displayName: 'App'
	# getInitialState: ->
	# 	errAdmin: 0
	# handleLogin: ->
	# 	socket.emit "adminLogin", {login: document.getElementById("login").value, password: document.getElementById("password").value}
	# componentWillMount: ->
	# 	socket.on "errAdminLogin", (data)=>
	# 		@setState errAdmin: data.type
	render: ->
		<div className="container">
			Learner
		</div>

module.exports = App