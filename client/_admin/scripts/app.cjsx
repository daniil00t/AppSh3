React = require 'react'
io = require "socket.io-client"
socket = io('')
URL = require "url"
crypto = require('crypto')
ee = require "./ee"
Panel = require "./components/admin_panel"

App = React.createClass
	displayName: 'App'
	getInitialState: ->
		numErr: -1

		# Chat states
		chatHello: ""
	componentWillMount: ->
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
			socket.emit "importDB@soc", type: data.type
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
				<Panel data={{chat: {chatHello: @state.chatHello}}}/>
			</div>
		</div>

module.exports = App