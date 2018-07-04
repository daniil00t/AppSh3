React = require "react"
io = require "socket.io-client"
socket = io('')

Header = require "./components/header"
Main = require "./components/main_cnt"
ee = require "./ee"


configs = {}
socket.on "connected", (data)->
	configs = data


App = React.createClass
	displayName: "App"
	getInitialState: ->
		massages: []
		configsUsr: {}
	componentWillMount: ->
		### _ Preload _ ###
		isTouchDevice = !!navigator.userAgent.match(/(iPhone|iPod|iPad|Android|playbook|silk|BlackBerry|BB10|Windows Phone|Tizen|Bada|webOS|IEMobile|Opera Mini)/)
		if isTouchDevice
			if !confirm "Мы хотим вас предупредить, что наше приложение работает нестабильно на мобильных устройствах. Продолжить?"
				window.location.replace "http://192.168.100.9:3000/learner"
		
		### _ Socket events _ ###
		socket.on "connected", (data)=>
			@setState configsUsr: data

		socket.on "errorUsr@soc", (data)=>
			alert "Error: #{data.nameError}. NumError: #{data.noError}"

		socket.on "newMassageToChatUsers", (data)=>
			arr = @state.massages
			arr.push data
			@setState massages: arr

		socket.on "changeHello@soc", (data)=>
			_configsUsr = @state.configsUsr
			_configsUsr.hello = data.cnt
			@setState configsUsr: _configsUsr

		### _ EventEmitter events _ ###

		ee.on "changeNameUsr@ee", (data)=>
			socket.emit "changeNameUsr@soc", {id: @state.configsUsr.id, name: data.name}
		
		ee.on "changePathImgUsr@ee", (data)=>
			socket.emit "changePathImgUsr@soc", {id: @state.configsUsr.id, path: data.path}

		ee.on "addMassage", (data)=>
			arr = @state.massages
			_data = data
			_data.id = @state.configsUsr.id

			console.log _data
			arr.push _data
			@setState massages: arr
			socket.emit "addMassageToChat@soc", 
				{id: _data.id, nameUsr: _data.nameUsr, pathAva: _data.pathAva, massage: _data.massage}
		

	render: ->
		<div className="CHAT_APP">
			<Header />
			<Main massages={@state.massages} mydata={@state.configsUsr} hello={@state.configsUsr.hello}/>
		</div>
		


module.exports = App