React = require "react"
ee = require "../ee"

MultQ = React.createClass
	displayName: "MultQ"

	getInitialState: ->
		num: @props.data.num
		activeItems: []
	handleClickIl: (i, e)->
		if @state.activeItems.length < 2
			id = "Q_#{@state.num}_#{i}"
			document.getElementById(id).checked = !document.getElementById(id).checked
			value = +i
			ee.emit "updateAnswer", {type: "multQ", num: @state.num, val: value}
			
			data = @state.activeItems
			data.push i
			@setState activeItems: data
			# if @state.activeItems.length == 2
			# 	for q, j in @props.data.anses
			# 		if j != @state.activeItems[0] and j != @state.activeItems[1]
			# 			ids = "Q_#{@state.num}_#{j}"
			# 			document.getElementById(ids).disabled = true
		else
			if e.altKey
				for q, l in @state.activeItems
					if q == i
						data = @state.activeItems
						data.splice l, 1
						@setState activeItems: data
				id = "Q_#{@state.num}_#{i}"
				document.getElementById(id).checked = false
	handleDoubleClick:(e) ->
		i = +e.target.attributes[0].value.match(/(\$(\d+))/g)[0].match(/\d+/)[0]
		for q, l in @state.activeItems
			if q == i
				data = @state.activeItems
				data.splice l, 1
				@setState activeItems: data
		id = "Q_#{@state.num}_#{i}"
		document.getElementById(id).checked = false
	refCallback: (item)->
		if item
			item.getDOMNode().ondblclick = this.handleDoubleClick

		
	render: ->
		<div className="ItemMultQ">
			<h3 className="question multQuestion">{@state.num+1 + ". " + @props.data.question}</h3>
			<ul className="ulanses multulanses">
				{
					@props.data.anses.map (i, j)=>
						<li onClick={(e) => @handleClickIl.bind(@, j)(e)} ref={@refCallback} key={j} style={if j == @state.activeItems[@state.activeItems.length-1] or j == @state.activeItems[@state.activeItems.length-2] then {backgroundColor: "#8fcaf9", color: "#fff"}}><label onClick={false}><input onClick={false} type="checkbox" disabled="disabled" name={"Q_#{@state.num}"} id={"Q_#{@state.num}_#{j}"} value={j}/>{i}</label></li>
				}
			</ul>
		</div>

module.exports = MultQ