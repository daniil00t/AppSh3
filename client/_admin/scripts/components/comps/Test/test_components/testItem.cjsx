React = require "react"

dispatcher = require "../test.dispatcher"

TestItem = React.createClass
	displayName: "TestItem"
	handleEditTest: ->
		dispatcher.dispatch
			type: "EDIT_TEST",
			payload: @props.num
	handleRemoveTest: ->
		dispatcher.dispatch
			type: "REMOVE_TEST"
			payload: @props.num
	handleActiveTest: (e)->
		dispatcher.dispatch
			type: "ACTIVE_TEST"
			payload: @props.num
	render: ->
		<div className={"testItem #{if @props.active then "active" else "noactive"}"}>
			<div>
			<div 
				className={
					switch @props.data.subject
						when "Информатика"
							"testItem_header informat"
						when "Математика"
							"testItem_header matan"
						when "История"
							"testItem_header history"
				}
			>
				<span className="subject">{@props.data.subject}</span>
				<div className="controls">
					<i className="fas fa-pen" onClick={@handleEditTest}></i>
					<i className="fas fa-times-circle" onClick={@handleRemoveTest}></i>
				</div>
			</div>

			<div className="testItem_main_cnt">
				<span className="time" title="Время на выполнения теста в секундах">
					<i className="far fa-clock"></i>{@props.data.time} сек.
				</span>
				<span className="count_variants" title="Количество вариантов">
					<i className="fas fa-list-ul"></i>{@props.data.variants.length}
				</span>

				<p className="testItem_main_cnt_name" onClick={(e) => @handleActiveTest e} title="Активировать данный тест">
					{@props.data.name}
				</p>
				<span className="_id" title="test_id">
					{@props.data._id}
				</span>
			</div>
			</div>
		</div>

module.exports = TestItem