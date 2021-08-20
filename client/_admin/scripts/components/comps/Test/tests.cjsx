React = require "react"

Block = require "./test_components/item_block_tests"
AddTest = require "./test_components/addTest"
EditTest = require "./test_components/editTest"
TestItem = require "./test_components/testItem"

test_dispatcher = require "./test.dispatcher"
main_dispatcher = require "../../../events/dispatchers/main_dispatcher"

Notification = require "../notification"

Test = React.createClass
	displayName: "Test"

	getInitialState: ->
		users: []
		tests: []
		activeTest: 0
		displayTestBlock: {
			visible: false,
			title: "",
			type: "",
			payload: []
		}

	handleAddTest: ->
		@setState displayTestBlock: {visible: true, title: "Создание нового теста", type: "add"}

	componentWillMount: ->
		# main_dispatcher.dispatch
		# 	type: "NOTIFICATION"
		# 	payload: {
		# 		type: "event"
		# 		data: {
		# 			type: "success"
		# 			massage: "Success!"
		# 		}
		# 	}

		test_dispatcher.register (action)=>
			switch action.type
				when "EDIT_TEST"
					@setState displayTestBlock: {visible: true, title: "Редактирование теста", type: "edit", data: @state.tests[action.payload]}
				when "REMOVE_TEST"
					main_dispatcher.dispatch
						type: "NOTIFICATION"
						payload: {
							type: "main"
							data: {
								type: "prompt"
								typeInput: "password"
								title: "Введите пароль админа"
								ph: "password"
								discr: {
									type: "DELETE_TEST"
									id: action.payload
								}
							}
						}
					arr = @state.tests
					arr.map (i, j)=>
						if i._id == action.payload
							arr.splice j, 1
					@setState tests: arr
 
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
					if action.payload.type_test == "add"
						arr = @state.tests
						arr.push action.payload
						@setState displayTestBlock: {
							visible: false,
							title: "",
							type: "",
							payload: []
						}, tests: arr
					else
						@setState displayTestBlock: {
							visible: false,
							title: "",
							type: "",
							payload: []
						}
						main_dispatcher.dispatch
							type: "NOTIFICATION"
							payload: {
								type: "event"
								data: {
									type: "success"
									massage: "Success!"
								}
							}

				when "ACTIVE_TEST"
					main_dispatcher.dispatch action
					@setState activeTest: action.payload
		main_dispatcher.register (action)=>
			switch action.type
				when "GET_ACTIVE_TEST"
					@setState activeTest: action.payload
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
								<TestItem data={i} num={j} active={if @state.activeTest == j then true else false}/>
					}
					<div className="testItem addTest">
						<div>
							<span className="plus" onClick={@handleAddTest}>+</span>
						</div>
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