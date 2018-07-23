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
		<header className="main_header">
			<h1 className="brand_app"><span className="t_brand">T</span>est</h1>
			<div className="inf_user">
				<div className="lbs_header">
					<span>Имя:</span><br/>
					<span>Фамилия: </span>
				</div>

				<div className="inps_header">
					<input type="text" id="name_user" /><br/>
					<input type="text" id="lastname_user" />
				</div><br/>
				<button className="save_inf_user" onClick={@handleClickSaveName}>Сохранить</button>
			</div>
			<div className="changeVariant">
				<h4>Вариант: </h4>
				<select id="selectVariant" onChange={(e) => @handleChangeSelect e}>
					{
						@props.data.map (i, j)=>
							if j is 0
								<option selected="selected" value="1">1</option>
							else
								<option value={j + 1}>{j + 1}</option>
					}
				</select>
			</div>
			<div className="TimerTest">
				<h1>{"#{if @state.time.minutes < 10 then "0#{@state.time.minutes}" else @state.time.minutes}:#{if @state.time.seconds < 10 then "0#{@state.time.seconds}" else @state.time.seconds}"}</h1>
				<i className="fa fa-play" onClick={@handleStartTest}></i>
			</div>
		</header>

# <div class="item html">
# 		    <h2>0</h2>
# 		    <svg width="160" height="160" xmlns="http://www.w3.org/2000/svg">
# 		     <g>
# 		      <title>Layer 1</title>
# 		      <circle id="circle" class="circle_animation" r="69.85699" cy="81" cx="81" stroke-width="8" stroke="#6fdb6f" fill="none"/>
# 		     </g>
# 		    </svg>
# 		</div>
# 		<script>
# 			time = 60
# 			initialOffset = '440'
# 			i = 1


# 			$('.circle_animation').css('stroke-dashoffset', initialOffset-(1*(initialOffset/time)))

# 			interval = setInterval(->
# 				$('h2').text(i)
# 				if i == time
# 					clearInterval(interval)
# 					return
				
# 				$('.circle_animation').css('stroke-dashoffset', initialOffset-((i+1)*(initialOffset/time)))
# 				i++;
# 			}, 1000);
# 		</script>
module.exports = Header