React 	= require 'react'
io 			= require "socket.io-client"
socket 	= io('')
URL 		= require "url"
crypto 	= require('crypto')

App = React.createClass
	displayName: 'App'
	getInitialState: ->
		users_data: {}
	

	componentWillMount: ->
		console.log "init webquest"
	render: ->
		<div className="pain_area">
			<h1 className="text-center">Hello world!</h1>
		</div>

module.exports = App