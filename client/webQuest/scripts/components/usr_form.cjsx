React = require "react"

UsrForm = React.createClass
	displayName: "UsrForm"
	getInitialState: ->
		state: false

	componentWillReceiveProps: (props)->
		@setState state: props.state
	render: ->
		<div className="usr_form fadeInLeft animated" style={display: if @state.state then "block" else "none"}>
			<h2>WebQuest v0.0.0</h2>
			<p className="caption">Input your name:</p>
			<input type="text"/><br />
			<button>Start</button>
			<div className="mini-footer">2018&copy;Daniil Shenyagin</div>
		</div>

module.exports = UsrForm