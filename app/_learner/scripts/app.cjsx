React = require 'react'
io = require "socket.io-client"
ee = require "./ee"
socket = io ""
Header = require "./components/Header"

DefQ = require "./components/defQ"
MultQ = require "./components/multQ"
JoinQ = require "./components/joinQ"
InpQ = require "./components/inpQ"


config = {}
socket.on "connected", (data)->
	console.log data
	config["id"] = data.id
	config["ip"] = data.ip
window.onbeforeunload = ->
	socket.emit "closed", {id: config.id}

console.log config


App = React.createClass
	displayName: 'App'
	getInitialState: ->
		DATA: []
		_data: []
		preloader: true
		variant: 1
		data_user: {}
		start: false
		ban: false
	# handleLogin: ->
	# 	socket.emit "adminLogin", {login: document.getElementById("login").value, password: document.getElementById("password").value}
	endTest: (massage) ->
		ee.emit "endTest", {type: on}
		socket.emit "sendDataTest", data: @state._data, data_user: @state.data_user
		alert massage
		window.location.replace("http://#{window.location.host}/learner")
	handleEndTest: ->
		@endTest "Пожайлуста, подождите. Данные вот-вот доберутся до сервера..."
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
		ee.on "changeVariant", (data)=>
			@setState variant: +data.value
		ee.on "changeUserData", (data)=>
			obj = {}
			obj.firstname_user = data.firstname
			obj.lastname_user = data.lastname
			socket.emit "setNameForTest", {id: config.id, firstname_user: obj.firstname_user, lastname_user: obj.lastname_user}
			@setState data_user: obj
			# @setState firstname_user: data.firstname
			# @setState lastname_user: data.lastname
		ee.on "stopTimer", (data)=>
			@endTest "К сожалению, время закончилось. Сохраняю ваши данные..."
		ee.on "startTestapp", (data)=>
			if @state.data_user.firstname_user? and @state.data_user.lastname_user?
				ee.emit "startTesth", type: on
				@setState start: data.type
			else
				ee.emit "startTesth", type: no
		socket.on "deleteUser_toClient", (data)=>
			if config.id is data.id

				alert data.massage
				@setState ban: true
				# window.location.replace("http://#{window.location.host}/learner")
		socket.on "UserInBan", (data)=>
			@setState ban: if data.type then false
	render: ->
		if !@state.ban
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
					<Header data={@state.DATA}/>
					{
						if @state.DATA.length isnt 0 and @state.start
							@state.DATA.map (i, j)=>
								if @state.variant == j + 1 and i.data.length isnt 0
									i.data.map (q, w)->
										switch q.type
											when "defQ"
												<div><DefQ data={q} /><hr /></div>
											when "multQ"
												<div><MultQ data={q} /><hr /></div>
											when "joinQ"
												<div><JoinQ data={q} /><hr/></div>
											when "inpQ"
												<div><InpQ data={q} /></div>
											else
												console.log "elses"
						else
							if @state.DATA.length is 0
								<div>К сожалению, данных нет.</div>
							else
								if !@state.start
									<div className="text-center nostart">Нажмите на кнопку старта таймера и давайте начинать!</div>
					}
					<button onClick={@handleEndTest} className="endTest">Завершить</button>
				<footer className="main_footer">

				</footer>
				</div>
			</div>
		else
			<span>Поздравляю, вы в бане!</span>

module.exports = App