React = require 'react'
io = require "socket.io-client"
socket = io('http://192.168.100.12:3000')
ee = require "./ee"


DefQ = require "./components/defQ"
MultQ = require "./components/multQ"
JoinQ = require "./components/joinQ"


# socket.on "connected", (data)->
# 	console.log data
# 	config["id"] = data.id
# 	config["ip"] = data.ip
# window.onbeforeunload = ->
# 	socket.emit "closed", {id: config.id}
		

App = React.createClass
	displayName: 'App'
	getInitialState: ->
		DATA: []
	# handleLogin: ->
	# 	socket.emit "adminLogin", {login: document.getElementById("login").value, password: document.getElementById("password").value}
	componentWillMount: ->
		# socket.on "connected", (data)=>
		# 	@setState id: data.id, ip: data.ip

		socket.on "getDataTest", (data)=>
			arr = []
			for i in data
				arr.push i
			@setState DATA: arr
		ee.on "updateAnswer", (data)=>
			console.log data
	render: ->
		<div className="container">
			<header className="main_header">
				<h1>Test</h1>
			</header>
			{
				if @state.DATA.length isnt 0
					@state.DATA.map (i)=>
						console.log i
						switch i.type
							when "defQ"
								<div><DefQ data={i} /><hr /></div>
							when "multQ"
								<div><MultQ data={i} /><hr /></div>
							when "joinQ"
								<div><JoinQ data={i} /></div>
							else
								console.log "elses"
				else
					<div>Получаю данные...</div>
			}
		</div>

module.exports = App