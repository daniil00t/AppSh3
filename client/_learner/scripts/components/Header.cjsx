React = require "react"
ee = require "../ee"

Header = React.createClass
	displayName: "Header"
	getInitialState: ->
		time: {}
	handleClickSaveName: ->
		ee.emit "changeUserData", firstname: document.getElementById("name_user").value, lastname:document.getElementById("lastname_user").value
	handleChangeSelect: (e)->
		ee.emit "changeVariant", value: e.target.value
	handleStartTest: ->
		ee.emit "startTestapp", time: @state.time, type: on
		
	componentWillReceiveProps: ->
		time_seconds = 0
		@props.data.map (i, j)=>
			if j is 0 then time_seconds = i.time
		console.log time_seconds
		seconds = time_seconds % 60
		minutes = Math.floor time_seconds / 60
		obj = {}
		obj.seconds = seconds
		obj.minutes = minutes
		@setState time: obj
	componentWillMount: ->
		ee.on "startTesth", (data)=>
			if data.type
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
								<label for="lname">фамилия:</label>
							</div>
							<div className="inputs">
								<input type="text" id="fname" placeholder="Daniil" />
								<input type="text" id="lname" placeholder="Shenyagin" />
							</div>
						</form>
							<select name="variant" id="vars">
								<option value="1">1 вариант</option>
								<option value="2">2 вариант</option>
								<option value="3">3 вариант</option>
								<option value="4">4 вариант</option>
							</select>
						
					</div>
					<div className="col-md-3 col-lg-3 col-sm-4 menu-left">
						<div className="timer">
							<span className="time">10:00</span>
							<div className="controlls">
								<i className="fa fa-play"></i>
							</div>
						</div>
					</div>
				</div>
			</div>
		</header>


module.exports = Header