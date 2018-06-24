React = require "react"

MyMassage = React.createClass
	displayName: "MyMassage"
	render: ->
		<div className="my_massage">
			<div className="wrp">
				<span className="name">{@props.name}</span>
				<div className="ava"><img src={@props.srcUrlImg}/></div>
			</div>
			<div className="text">{@props.text}</div>
		</div>

module.exports = MyMassage