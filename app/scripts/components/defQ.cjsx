React = require "react"
ee = require "../ee"


DefQ = React.createClass
	displayName: "DefQ"
	getInitialState: ->
		num: @props.data.num
		activeItem: -1
	handleClickIl: (i)->
		id = "Q_#{@state.num}_#{i}"
		document.getElementById(id).checked = true
		console.log "i"
		value = +i
		ee.emit "updateAnswer", {type: "defQ", num: @state.num, val: value}
		@setState activeItem: value
	render: ->
		<div className="ItemDefQ">
			<h3 className="question defQuestion">{@state.num+1 + ". " + @props.data.question}</h3>
			<ul className="ulanses defulanses">
				{
					@props.data.anses.map (i, j)=>
						<li onClick={@handleClickIl.bind @, j} key={j} style={if j == @state.activeItem then {backgroundColor: "#8fcaf9", color: "#fff"}}><label><input type="radio" name={"Q_#{@state.num}"} id={"Q_#{@state.num}_#{j}"} value={j}/>{i}</label></li>
				}
			</ul>
		</div>

module.exports = DefQ