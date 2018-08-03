React = require 'react'
io = require "socket.io-client"
ee = require "./ee"
socket = io ""

dispatcher = require "./dispatcher"

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

	endTest: ->
		# ee.emit "endTest", {type: on}
		socket.emit "sendDataTest", data: @state.data_anses, data_user: @state.data_user
		window.location.replace("http://#{window.location.host}/learner")
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

				socket.emit "changeUsrData", { id: @state.data_user.id, type: key, payload: { value: value } }

		ee.on "startTestApp", (data)=>
			if @state.data_user.fname? and @state.data_user.lname?
				ee.emit "startTest", type: on
				@setState start: data.type

				socket.emit "changeUsrData", { id: @state.data_user.id, type: "start", payload: { state: on } }
			else
				ee.emit "startTest", type: no


		ee.on "sendAnswer", (data)=>
			Data = @state.data_anses
			Data.push data
			@setState data_anses: Data
		ee.on "changeVariant", (data)=>
			@setState variant: +data.value

			socket.emit "changeUsrData", { id: @state.data_user.id, type: "variant", payload: {value: +data.value} }

		ee.on "stopTimer", (data)=>
			@endTest()


		# Dispatcher events
		dispatcher.register (action)=>
			switch action.type
				when "UPDATE_ANSWER"
					socket.emit "UPDATE_ANSWER_USER", 
						id: @state.data_user.id
						payload: action.payload

					arr = @state.data_anses
					if arr.length > 0
						update = false
						for i, j in arr
							if i.no == action.payload.no
								arr[j].value = action.payload.value
								update = true
						if !update
							arr.push action.payload
					else
						arr.push action.payload
					@setState data_anses: arr
				when "UPDATE_ANSWER_REMOVE"
					socket.emit "UPDATE_ANSWER_REMOVE_USER", 
						id: @state.data_user.id
						payload: action.payload
				else
					console.log "свитч не сработал"
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
					<button onClick={@endTest} className="endTest">Завершить</button>
				<footer className="main_footer">
					<p className="text-center">Daniil Shenyagin&copy;2018 - TestingApp - SchoolProjects#3</p>
				</footer>
				</div>
			</div>
		else
			<span>Поздравляю, вы в бане!</span>

module.exports = App