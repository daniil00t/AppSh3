React = require "react"

MyMassage = React.createClass
	displayName: "MyMassage"
	render: ->
		<div className="my_massage">

			<div className="wrap">
				<p>
					{@props.text}
				</p>
			</div>
			<i className="fas fa-caret-right"></i>
		</div>

module.exports = MyMassage