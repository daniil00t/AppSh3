React = require 'react'
io = require "socket.io-client"
ee = require "./ee"
socket = io ""

Header = require "./components/Header"

DefQ = require "./components/defQ"
MultQ = require "./components/multQ"
JoinQ = require "./components/joinQ"
InpQ = require "./components/inpQ"


App = React.createClass
	displayName: 'App'
	getInitialState: ->
		data_test: []
		data_anses: []
		data_user: {}
		preloader: true
		variant: 1
		start: false

	endTest: (massage) ->
		ee.emit "endTest", {type: on}
		socket.emit "sendDataTest", data: @state.data_anses, data_user: @state.data_user
		alert massage
		window.location.replace("http://#{window.location.host}/learner")
	handleEndTest: ->
		@endTest "Пожайлуста, подождите. Данные вот-вот доберутся до сервера..."
	componentWillMount: ->
		### _ Sockets _ ###

		# Получение данных (клиента) с сервера (DB)
		socket.on "connected", (data)=>
			@setState data_user: data

		# Получение данных(тестов) с сервера (DB)
		socket.on "getDataTest", (data)=>
			arr = []
			for i in data
				arr.push i
			@setState data_test: arr
			@setState preloader: no

		### _ EventEmitter_  ###
		# Сохранение данных пользователя: имени и фамилии
		ee.on 'changeNameUsr@ee', (data)=>
			for key, value of data
				obj = @state.data_user
				obj[key] = value
				@setState data_user: obj

		ee.on "startTestApp", (data)=>
			if @state.data_user.fname? and @state.data_user.lname?
				ee.emit "startTest", type: on
				@setState start: data.type
			else
				ee.emit "startTest", type: no


		ee.on "sendAnswer", (data)=>
			Data = @state.data_anses
			Data.push data
			@setState data_anses: Data
		ee.on "changeVariant", (data)=>
			@setState variant: +data.value

		ee.on "stopTimer", (data)=>
			@endTest "К сожалению, время закончилось. Сохраняю ваши данные..."


		socket.on "deleteUser_toClient", (data)=>
			if config.id is data.id

				alert data.massage
				@setState ban: true
				# window.location.replace("http://#{window.location.host}/learner")
		socket.on "UserInBan", (data)=>
			@setState ban: if data.type then false
	render: ->
		if !@state.ban
			<div className="testing">
				<div className="preloader" style={display: if !@state.preloader then "none"}>
					<div className="cssload-thecube">
						<div className="cssload-cube cssload-c1"></div>
						<div className="cssload-cube cssload-c2"></div>
						<div className="cssload-cube cssload-c4"></div>
						<div className="cssload-cube cssload-c3"></div>
					</div>
				</div>
				<Header data={@state.data_test}/>
				<div className="container main_cnt">
					{
						if @state.data_test.length isnt 0 and @state.start
							@state.data_test.map (i, j)=>
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
							if @state.data_test.length is 0
								<div>К сожалению, данных нет.</div>
							else
								if !@state.start
									<div className="text-center nostart">Нажмите на кнопку старта таймера и давайте начинать!</div>
					}
					<button onClick={@handleEndTest} className="endTest">Завершить</button>
				<footer className="main_footer">
					<p className="text-center">Daniil Shenyagin&copy;2018 - TestingApp - SchoolProjects#3</p>
				</footer>
				</div>
			</div>
		else
			<span>Поздравляю, вы в бане!</span>

module.exports = App