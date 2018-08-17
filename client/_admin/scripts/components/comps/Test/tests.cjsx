React = require "react"

Block = require "./test_components/item_block_tests"
AddTest = require "./test_components/addTest"
EditTest = require "./test_components/editTest"
TestItem = require "./test_components/testItem"

test_dispatcher = require "./test.dispatcher"
main_dispatcher = require "../../dispatcher"

Notification = require "../notification"

Test = React.createClass
	displayName: "Test"


	getInitialState: ->
		users: []
		tests: []
		displayTestBlock: {
			visible: false,
			title: "",
			type: "",
			payload: []
		}
	handleAddTest: ->
		@setState displayTestBlock: {visible: true, title: "Создание нового теста", type: "add"}

	componentWillMount: ->
		test_dispatcher.register (action)=>
			switch action.type
				when "EDIT_TEST"
					@setState displayTestBlock: {visible: true, title: "Редактирование теста", type: "edit", data: @state.tests[action.payload]}
				when "REMOVE_TEST"
					main_dispatcher.dispatch
						type: "NOTIFICATION"
						payload: {
							type: "prompt"
							data: {
								typeInput: "password"
								title: "Введите пароль админа"
								ph: "password"
							}
						}

					# main_dispatcher.dispatch
					# 	type: "NOTIFICATION"
					# 	payload: {
					# 		type: "massage"
					# 		data: {
					# 			massage: "HEllo"
					# 		}
					# 	}
				when "SAVE_TEST"
					main_dispatcher.dispatch action

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

			<Block title="Тесты" classItem="testUtils">
				<div className="all_tests">
					{
						if @state.tests.length != 0
							@state.tests.map (i, j)=>
								<TestItem data={i} num={j}/>
					}
					<div className="testItem addTest">
						<span className="plus" onClick={@handleAddTest}>+</span>
					</div>
				</div>
			</Block>



			<Block title={@state.displayTestBlock.title} classItem="AddTest" display={@state.displayTestBlock.visible}>
				{
					switch @state.displayTestBlock.type
						when "add"
							<AddTest classItem="addTestBlock"/>
						when "edit"
							<EditTest classItem="addTestBlock" data={@state.displayTestBlock.data}/>
				}
			</Block>

			<Block title="Изменение состояния приложения" classItem="changeState">
				<div>
					Block#2
				</div>
			</Block>

		</div>

module.exports = Test