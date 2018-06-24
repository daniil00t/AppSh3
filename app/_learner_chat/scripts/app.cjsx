React = require "react"
io = require "socket.io-client"
socket = io('')

Header = require "./components/header"
Main = require "./components/main_cnt"
ee = require "./ee"


configs = {}
socket.on "connected", (data)->
	configs = data

window.onbeforeunload = ->
	console.log configs
	socket.emit "closed", id: configs.id


App = React.createClass
	displayName: "App"
	getInitialState: ->
		massages: []
		configsUsr: {}
	componentWillMount: ->
		socket.on "connected", (data)=>
			@setState configsUsr: data

		ee.on "addMassage", (data)=>
			arr = @state.massages
			arr.push data
			@setState massages: arr


	render: ->
		<div className="CHAT_APP">
			<Header />
			<Main />
		</div>
		


module.exports = App