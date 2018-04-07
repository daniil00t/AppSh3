React = require 'react'
io = require "socket.io-client"
ee = require "./ee"
socket = io ""
Header = require "./components/Header"

DefQ = require "./components/defQ"
MultQ = require "./components/multQ"
JoinQ = require "./components/joinQ"
InpQ = require "./components/inpQ"



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
		_data: []
		preloader: true
	# handleLogin: ->
	# 	socket.emit "adminLogin", {login: document.getElementById("login").value, password: document.getElementById("password").value}
	handleEndTest: ->
		ee.emit "endTest", {type: on}
		socket.emit "sendDataTest", data: @state._data
		alert "Пожайлуста, подождите. Данные вот-вот доберутся до сервера..."
		window.location.replace("http://#{window.location.host}/learner")
	componentWillMount: ->
		# socket.on "connected", (data)=>
		# 	@setState id: data.id, ip: data.ip
		socket.on "getDataTest", (data)=>
			arr = []
			for i in data
				arr.push i
			@setState DATA: arr
			@setState preloader: no

		# ee.on "updateAnswer", (data)=>
		# 	Data = @state._data
		# 	Data.push data
		# 	@setState _data: Data
		# 	console.log data

		ee.on "sendAnswer", (data)=>
			Data = @state._data
			Data.push data
			@setState _data: Data
	render: ->
		<div>
			<div className="preloader" style={display: if !@state.preloader then "none"}>
				<div className="cssload-thecube">
					<div className="cssload-cube cssload-c1"></div>
					<div className="cssload-cube cssload-c2"></div>
					<div className="cssload-cube cssload-c4"></div>
					<div className="cssload-cube cssload-c3"></div>
				</div>
			</div>
			<div className="container">
				<Header />
				{
					if @state.DATA.length isnt 0
						@state.DATA.map (i)=>
							switch i.type
								when "defQ"
									<div><DefQ data={i} /><hr /></div>
								when "multQ"
									<div><MultQ data={i} /><hr /></div>
								when "joinQ"
									<div><JoinQ data={i} /><hr/></div>
								when "inpQ"
									<div><InpQ data={i} /></div>
								else
									console.log "elses"
					else
						<div>Получаю данные...</div>
				}
				<button onClick={@handleEndTest} className="endTest">Завершить</button>
			<footer className="main_footer">

			</footer>
			</div>
		</div>

module.exports = App