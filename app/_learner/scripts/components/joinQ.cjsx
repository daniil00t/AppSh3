React = require "react"
ee = require "../ee"



JoinQ = React.createClass
	displayName: "JoinQ"
	getInitialState: ->
		configs: {
			count_items: @props.data.anses[0].firstItems.length
		}
		heightSVG: 0
		colors: ["#2B9483", "#2866F7", "#FC911A", "#DB381B"]
		coordsItems: {
			first: ["0 19", "0 60", "0 100"],
			second: ["300 19", "300 60", "300 100"]
		}
		paths: []
		tmpPath: []
		arrCoordsPaths: []
		alphabet: {rus: ["а", "б", "в", "г", "д", "е", "ж", "з", "и", "к"], en: ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", ]}
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
		if @state.paths.length < @state.configs.count_items
			if type is "f"
				data = @state.tmpPath
				data.push {num: j, type: type}
				@setState tmpPath: data
			else
				if @state.tmpPath.length != 0
					data = @state.tmpPath
					data.push {num: j, type: type}
					@setState tmpPath: data



					@drawPath [@state.tmpPath[0].num, @state.tmpPath[1].num]
					_data = @state.paths
					_data.push @state.tmpPath
					@setState paths: _data

					@setState tmpPath: []
	drawPath: (arrCoords)->
		data = @state.arrCoordsPaths
		data.push arrCoords
		@setState arrCoordsPaths: data
	componentWillMount: ->
		ee.on "endTest", (data)=>
			ee.emit "sendAnswer", {type: "joinQ", num: @props.data.num, ans: @state.paths}
	render: ->
		<div className="joinQ">
			<h3 className="question">{"#{@props.data.num + 1}. #{@props.data.question}"}</h3>
			<div className="wrap">
				<div className="firstAnses one">
					<ul>
						{
							@props.data.anses[0].firstItems.map (i, j)=>
								<li onClick={(e) => @handleJoin.bind(@, j) e, "f"} style={backgroundColor: @state.colors[j]} onMouseOver={@hoverOverLiFirstAns.bind(@, j)}  onMouseOut={@hoverOutLiFirstAns.bind(@, j)} id={"Q_F_#{j}"}>{"#{@state.alphabet.rus[j].toUpperCase()}. #{i}"}<br /></li>
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
							<li onClick={(e) => @handleJoin.bind(@, j) e, "s"} id={"Q_S_#{j}"}>{"#{j+1}. #{i}"}<br /></li>
					}
					</ul>
				</div>
				<table className="ansesTable" border="2">
					<tr>
						{
							@props.data.anses[0].firstItems.map (i, j)=>
								<td>{@state.alphabet.rus[j].toUpperCase()}</td>
						}
					</tr>
					<tr>
						{
							arr = @state.paths
							len = arr.length - 1 
							i = 0
							while i < len
								j = 0
								while j < len - i
									if arr[j][0].num > arr[j+1][0].num
										max = arr[j]
										arr[j] = arr[j+1]
										arr[j+1] = max
									j++
								i++
							arr.map (i, j)=>
								if i[0].num == j
									<td>{i[1].num + 1}</td>
						}
					</tr>
				</table>
			</div>
		</div>

module.exports = JoinQ