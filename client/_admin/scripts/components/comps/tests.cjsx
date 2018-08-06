React = require "react"

dispatcher = require "../dispatcher"


Test = React.createClass
	displayName: "Test"
	getInitialState: ->
		users: []
	drawChart: ->
		data = google.visualization.arrayToDataTable([
			['Task', 'соотношение справившихся к несправившихся'],
			['Справились',     19],
			['Провалили',      7],
		]);

		chart = new google.visualization.PieChart(@chartContainer)
		chart.draw(data)
	componentWillMount: ->
		if @props.users.length == 0
			dispatcher.register (action)=>
				switch action.type
					when "INIT_LOAD_USER_TO_TESTS_COMPONENT"
						@setState users: action.payload
		else
			@setState users: @props.users.data
	componentDidMount: ->
		google.charts.load("current", {packages:["corechart"]})
		google.charts.setOnLoadCallback(@drawChart);
	render: ->

		<div className="test_admin_panel">
			<h2>Статистика</h2><hr/>

			<div className="items row">
				<div ref={(node) => @chartContainer = React.findDOMNode(node)} className="item countSuccess_item" data-title="Cоотношение справившихся к несправимшихся"></div>
				<div className="item mid_points" data-title="Общий балл тестирующихся">
					<p className="mid_points_value">4.15</p>
				</div>
				<div className="item best_tester" data-title="Лучший ученик">
					<div className="user">
						<div className="name"></div>
						<div className="points"></div>
						<div className="controlls">
							<div className="info"></div>
							<div className="link"></div>
						</div>
					</div>
				</div>
			</div>
			<div className="items row">
				<div className="item"></div>
				<div className="item"></div>
				<div className="item"></div>
			</div>
		</div>


		
module.exports = Test