React = require "react"

Massage = React.createClass
	displayName: "Massage"
	render: ->
		<div className="massage">
			<div className="wrp">
				<div className="ava"><img src={@props.srcUrlImg}/></div>
				<span className="name">{@props.name}</span>
			</div>
			<div className="text">{@props.text}</div>
		</div>

module.exports = Massage