React = require "react"
ee = require "../ee"



JoinQ = React.createClass
	displayName: "JoinQ"
	getInitialState: ->
		heightSVG: 0
		colors: ["#2B9483", "#2866F7", "#FC911A", "#DB381B"]
		coordsItems: {
			first: ["0 19", "0 60", "0 100"],
			second: ["300 19", "300 60", "300 100"]
		}
		paths: []
		tmpPath: []
		arrCoordsPaths: []
	componentDidMount: ->
		@setState heightSVG: document.getElementsByClassName("firstAnses")[0].offsetHeight
	hoverOverLiFirstAns: (j)->
		bgc = document.getElementById("Q_F_#{j}").style.backgroundColor
		arr = []
		bgc.replace /rgb\((\w*), (\w*), (\w*)\)/g, (match, g1, g2, g3)->
			arr.push g1, g2, g3
		document.getElementById("Q_F_#{j}").style.backgroundColor = "rgba(#{arr[0]}, #{arr[1]}, #{arr[2]}, 0.9)"
	hoverOutLiFirstAns: (j)->
		document.getElementById("Q_F_#{j}").style.backgroundColor = @state.colors[j]
	handleJoin: (j, e, type)->
		if @state.paths.length < 3
			if type is "f"
				console.log j
				data = @state.tmpPath
				data.push {num: j, type: type}
				@setState tmpPath: data
			else
				console.log j
				data = @state.tmpPath
				data.push {num: j, type: type}
				@setState tmpPath: data



				@drawPath [@state.tmpPath[0].num, @state.tmpPath[1].num]
				_data = @state.paths
				_data.push @state.tmpPath
				@setState paths: _data

				@setState tmpPath: []
	drawPath: (arrCoords)->
		console.log arrCoords
		data = @state.arrCoordsPaths
		data.push arrCoords
		@setState arrCoordsPaths: data
		console.log @state.arrCoordsPaths
	render: ->
		<div className="joinQ">
			<div className="wrap">
				<div className="firstAnses one">
					<ul>
						{
							@props.data.anses[0].firstItems.map (i, j)=>
								<li onClick={(e) => @handleJoin.bind(@, j) e, "f"} style={backgroundColor: @state.colors[j]} onMouseOver={@hoverOverLiFirstAns.bind(@, j)}  onMouseOut={@hoverOutLiFirstAns.bind(@, j)} id={"Q_F_#{j}"}>{i}<br /></li>
						}
					</ul>
				</div>
				<svg className="lines joinQsvg" height={@state.heightSVG}>
					{
						if @state.arrCoordsPaths.length != 0
							@state.arrCoordsPaths.map (i)=>
								<path d="M #{@state.coordsItems.first[i[0]]} L #{@state.coordsItems.second[i[1]]} Z"  fill="transparent" stroke="#333" style={{strokeWidth: 2}}></path>
					}
				</svg>
				<div className="secondAnses two">
					<ul>
					{
						@props.data.anses[0].secondItems.map (i, j)=>
							<li onClick={(e) => @handleJoin.bind(@, j) e, "s"} id={"Q_S_#{j}"}>{i}<br /></li>
					}
					</ul>
				</div>
			</div>
		</div>

module.exports = JoinQ