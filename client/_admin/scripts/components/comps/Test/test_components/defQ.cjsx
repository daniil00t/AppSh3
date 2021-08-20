React = require "react"
# ee = require "../ee"

dispatcher = require "../test.dispatcher"

DefQ = React.createClass
	displayName: "DefQ"
	getInitialState: ->
		num: @props.num
		activeItem: -1
		alphabet: {rus: ["а", "б", "в", "г", "д", "е", "ж", "з", "и", "к"], en: ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]}
		myans: {}
	handleClickIl: (i, e)->
		if e.target.localName == "span" or e.target.localName == "li" or e.target.localName == "label"
			if e.altKey and @state.activeItem == i
				@setState activeItem: -1
				dispatcher.dispatch
					type: "UPDATE_ANSWER_REMOVE",
					payload: 
						type: "defQ",
						no: @state.num
			else
				id = "Q_#{@state.num}_#{i}"
				document.getElementById(id).checked = true
				value = +i
				@setState myans: {type: "defQ", num: @state.num, val: value}
				dispatcher.dispatch
					type: "NEW_TRUE_ANSWER",
					payload: 
						type: "defQ",
						no: @state.num,
						value: value
				# ee.emit "updateAnswer", {type: "defQ", num: @state.num, val: value}
				@setState activeItem: value
	handleAddItem: ->
		dispatcher.dispatch
			type: "ADD_ITEM_PROBLEM"
			payload: {
				value: React.findDOMNode(@newItemValue_problem).value,
				num: @state.num
			}
		React.findDOMNode(@newItemValue_problem).value = ""
	componentWillMount: ->
		if @props.data.trueanses?
			@setState activeItem: @props.data.trueanses[0]
	componentWillReceiveProps: (np)->
		if np.data.trueanses?
			@setState activeItem: np.data.trueanses[0]
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
								<input type="radio" name={"Q_#{@state.num}"} id={"Q_#{@state.num}_#{j}"} disabled="disabled" value={j} dangerouslySetInnerHTML={{__html: "#{@state.alphabet.rus[j].toUpperCase()}. #{i}"}} />
							</label>
						</li>
				}
				<input type="radio" disabled="disabled" className="inputRadioItemToProblem"/>
				<input type="text" className="inputTextItemToProblem" ref={(node) => @newItemValue_problem = node}/>
				<button className="defButtonWithText addItemToProblem" data-title="add Item" onClick={@handleAddItem}>+</button>
			</ul>
		</div>

module.exports = DefQ