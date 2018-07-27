React = require "react"
ee = require "../ee"

Header = React.createClass
	displayName: "Header"
	getInitialState: ->
		time: {}
		start: false
	# выбор варианта
	handleChangeSelect: (e)->
		@inputBlur(@selectVar)
		ee.emit "changeVariant", value: e.target.value
	# стартуем тест
	handleStartTest: ->
		if !@state.start
			ee.emit "startTestApp", time: @state.time, type: on
					
	
	# просто нужно понять, что тут вычисляется время в минутах и секундах
	componentWillReceiveProps: ->
		time_seconds = 0
		@props.data.map (i, j)=>
			if j is 0 then time_seconds = i.time
		seconds = time_seconds % 60
		minutes = Math.floor time_seconds / 60
		obj = {}
		obj.seconds = seconds
		obj.minutes = minutes
		@setState time: obj

	# изменение имени и фамилия
	changeName: (e)->
		val = e.key
		if val == "Enter"
			value = e.target.value
			# Очищаем textarea
			if e.target.id is "fname"
				@inputFocus(@lname)
				@inputBlur(@fname)
				console.log "fname: ", value
				ee.emit "changeNameUsr@ee", fname: value
			else
				console.log "lname: ", value
				ee.emit "changeNameUsr@ee", lname: value
				@inputFocus(@selectVar)

	# самый обычный focus в js
	inputFocus: (node)->
		_node = React.findDOMNode(node) # returned <input />
		if _node?
			_node.focus()

	# самый обычный blur в js
	inputBlur: (node)->
		_node = React.findDOMNode(node) # returned <input />
		if _node?
			_node.blur()
	componentWillMount: ->
		ee.on "startTest", (data)=>
			if data.type
				@setState start: on
				timeall = @state.time.minutes * 60 + @state.time.seconds
				console.log timeall
				SI = setInterval (=>
					if timeall is 1
						clearInterval SI
						# STOP Timer
						ee.emit "stopTimer", {type: on}
					else
						timeall--
						obj = {}
						obj.seconds = timeall % 60
						obj.minutes = Math.floor timeall / 60
						@setState time: obj
				),1000
			else
				alert "Введите свое имя и фамилие!"
	componentDidMount: ->
		@inputFocus(@fname)
	render: ->
		<header className="main_header_test">
			<div className="container-fluid">
				<div className="row">
					<div className="col-md-3 col-lg-3 col-sm-0 logo">
						<div className="logo">
							<a href="/learner/test"><img src="http://localhost:8080/imgFiles/testing_black.png" /></a>
						</div>
					</div>
					<div className="col-md-6 col-lg-6 col-sm-8 main_part_header">
						<form action="" className="change_dataUsr">
							<div className="labels">
								<label for="fname">имя:</label><br />
								<label for="lname">фамилие:</label>
							</div>
							<div className="inputs">
								<input type="text" id="fname" placeholder="Daniil" ref={(node) => @fname = node} onKeyDown={(e) => @changeName e}/>
								<input type="text" id="lname" placeholder="Shenyagin" ref={(node) => @lname = node} onKeyDown={(e) => @changeName e}/>
							</div>
						</form>
							<select name="variant" id="selectVariant" onChange={(e) => @handleChangeSelect e} ref={(node) => @selectVar = node}>
								{
									for i, j in @props.data
										<option value={j + 1}>{j + 1} вариант</option>
								}
							</select>
						
					</div>
					<div className="col-md-3 col-lg-3 col-sm-4 menu-left">
						<div className="timer">
							<span className="time">{"#{if @state.time.minutes < 10 then "0" + @state.time.minutes else @state.time.minutes}:#{if @state.time.seconds < 10 then "0" + @state.time.seconds else @state.time.seconds}"}</span>
							<div className="controlls">
								<i className="fa fa-play" onClick={@handleStartTest} style={color: if @state.start then "#dadada" else "white"}></i>
							</div>
						</div>
					</div>
				</div>
			</div>
		</header>


module.exports = Header