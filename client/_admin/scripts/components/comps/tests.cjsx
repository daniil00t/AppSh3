React = require "react"


Test = React.createClass
	displayName: "Test"
	drawChart: ->
		data = google.visualization.arrayToDataTable([
			['Task', 'соотношение справившихся к несправившихся'],
			['Справились',     19],
			['Провалили',      7],
		]);

		chart = new google.visualization.PieChart(@chartContainer)
		chart.draw(data)
	componentDidMount: ->
		google.charts.load("current", {packages:["corechart"]})
		google.charts.setOnLoadCallback(@drawChart);
	render: ->

		<div className="items test_admin_panel">
			<h2>Статистика</h2><hr/>
			<div ref={(node) => @chartContainer = React.findDOMNode(node)} className="item countSuccess_item" data-task="Cоотношение справившихся к несправившихся"></div>
			# <div className="item"></div>
		</div>


		
module.exports = Test