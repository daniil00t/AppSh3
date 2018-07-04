React = require "react"

MyMassage = React.createClass
	displayName: "MyMassage"
	render: ->
		<div className="my_massage">
			<p>
				{@props.text}
			</p>
			<i className="fas fa-caret-right"></i>
		</div>

module.exports = MyMassage