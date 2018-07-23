React = require "react"
ee = require "../ee"


DefQ = React.createClass
	displayName: "DefQ"
	getInitialState: ->
		num: @props.data.num
		activeItem: -1
		alphabet: {rus: ["а", "б", "в", "г", "д", "е", "ж", "з", "и", "к"], en: ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", ]}
		myans: {}
	handleClickIl: (i, e)->
		if e.target.localName == "span" or e.target.localName == "li"
			id = "Q_#{@state.num}_#{i}"
			document.getElementById(id).checked = true
			value = +i
			@setState myans: {type: "defQ", num: @state.num, val: value}
			# ee.emit "updateAnswer", {type: "defQ", num: @state.num, val: value}
			@setState activeItem: value
	componentWillMount: ->
		ee.on "endTest", (data)=>
			ee.emit "sendAnswer", @state.myans
	render: ->
		<div className="ItemDefQ">
			<h3 className="question defQuestion">{@state.num+1 + ". " + @props.data.question}</h3>
			<ul className="ulanses defulanses">
				{
					@props.data.anses.map (i, j)=>
						
						<li onClick={(e) => @handleClickIl.bind(@, j)(e)} 
							key={j} 
							style={if j == @state.activeItem then {backgroundColor: "#3670F7", color: "#fff", boxShadow: "0 0 15px rgba(0,0,0,0.6)"}}>
							<label>
								<input type="radio" name={"Q_#{@state.num}"} id={"Q_#{@state.num}_#{j}"}  disabled="disabled" value={j}  dangerouslySetInnerHTML={{__html: "#{@state.alphabet.rus[j].toUpperCase()}. #{i}"}} />
							</label>
						</li>
				}
			</ul>
		</div>

module.exports = DefQ