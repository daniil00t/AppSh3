React = require "react"
ee = require "../ee"
InpQ = React.createClass
	displayName: "InpQ"
	componentWillMount: ->
		ee.on "endTest", (data)=>
			ee.emit "sendAnswer", {type: "inpQ", num: @props.data.num, val: document.getElementById("ans").value}
	render: ->
		<div className="inpQ">
			<h3 className="question defQuestion">{@props.data.num+1 + ". " + @props.data.question}</h3>
			<p>
			{@props.data.text}
			</p>
			<input type="text" id="ans"/>
		</div>
#  onChange={@handleChange} 
module.exports = InpQ