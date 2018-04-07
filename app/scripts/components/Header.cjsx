React = require "react"
ee = require "../ee"

Header = React.createClass
	displayName: "Header"
	getInitialState: ->
		name: ""
		lastname: ""
	handleClickSaveName: ->
		@setState name: document.getElementById("name_user").value
		@setState lastname: document.getElementById("lastname_user").value
	render: ->
		<header className="main_header">
			<h1 className="brand_app">Test</h1>
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
				<select id="selectVariant">
					<option selected="selected" value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
				</select>
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