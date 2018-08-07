React = require "react"

Block = require "./test_components/item_block_tests"


Test = React.createClass
	displayName: "Test"

	render: ->
		<div className="testPanel">
			<h1 className="welcome_chat_panel">
				Управление тестами
			</h1>

			<Block title="Работа с тестами">
				<div>
					Block#1
				</div>
			</Block>

			<Block title="Изменение состояния приложения">
				<div>
					Block#2
				</div>
			</Block>

		</div>

module.exports = Test