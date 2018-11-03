React 	= require 'react'
io 			= require "socket.io-client"
socket 	= io('')
URL 		= require "url"
crypto 	= require('crypto')

#Required Components
UsrForm = require "./components/usr_form"


App = React.createClass
	displayName: 'App'
	getInitialState: ->
		users_data: {}

		# components
		form: false
	

	componentWillMount: ->
		console.log "init webquest"
	componentDidMount: ->
		setTimeout (=>
			@setState form: true
		), 5000
	render: ->
		<div className="main_area">
			<div className="wrp_main_area">
				<h1 className="welcome text-center" style={display: if @state.form then "none" else "block"}>Hello world!</h1>

				<UsrForm state={@state.form}/>
				
			</div>
		</div>
#<h1 className="welcome text-center" ref={(node) -> @welcome = node}>Hello world!</h1>
###
	

###

module.exports = App