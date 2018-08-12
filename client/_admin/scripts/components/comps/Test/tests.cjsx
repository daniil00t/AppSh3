React = require "react"

Block = require "./test_components/item_block_tests"
AddTest = require "./test_components/addTest"


Test = React.createClass
	displayName: "Test"

	getInitialState: ->
		users: []
		tests: []
	componentWillMount: ->
		@setState
			tests: @props.tests
			users: @props.users

	componentWillReceiveProps: (newProps)->
		@setState
			tests: newProps.tests
			users: newProps.users
	render: ->
		<div className="testPanel">
			<h1 className="welcome_chat_panel">
				Управление тестами
			</h1>

			<Block title="Работа с тестами" classItem="testUtils">
				<div className="all_tests">
					{
						if @state.tests.length != 0
							@state.tests.map (i, j)=>
								<div className="testItem">
									{
										"Тема теста: #{i.name}"
									}
									<br />
									{
										"Предмет: #{i.subject}"
									}
								</div>
					}
				</div>
				<br />
				<button className="addTest">+</button>
				<AddTest />
			</Block>

			<Block title="Изменение состояния приложения" classItem="changeState">
				<div>
					Block#2
				</div>
			</Block>

		</div>

module.exports = Test