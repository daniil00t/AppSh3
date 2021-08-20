React = require "react"

dispatcher = require "../test.dispatcher"

DefQ = require "./defQ"
# MultQ = require "./multQ"
# JoinQ = require "./joinQ"
# InpQ = require "./inpQ"

AddTest = React.createClass
	displayName: "AddTest"
	getInitialState: ->
		data: {}
		addedVariant: false
		addedProblem: false
		initData: {subject: "Информатика"}
		variant: 0
		allProblems: [[]]
		count_reload_render: 0
	addAnsToProblems: ->
		obj = {type: React.findDOMNode(@tmpTypeProblem).value, question: React.findDOMNode(@tmpAskProblem).value, anses: [], num: @state.allProblems[@state.variant].length, score: 1}
		arr = @state.allProblems
		arr[@state.variant].push obj
		@setState allProblems: arr
	componentWillMount: ->

		if @state.count_reload_render == 0
			# Init
			@setState initData: {nameTest: @props.data.name, timeTest: @props.data.time, subjectTest: @props.data.subject}
			arrAllProblems = @props.data
			if arrAllProblems? and arrAllProblems.variants.length > 0
				arrAllProblems.variants.map (i, j)=>
					i.map (k, l)=>
						arrAllProblems.variants[j][l].num = l
			@setState data: arrAllProblems, allProblems: @props.data.variants
		

		dispatcher.register (action)=>
			switch action.type
				when "ADD_ITEM_PROBLEM"
					arr = @state.allProblems
					arr[@state.variant].map (i, j)=>
						if i.num == action.payload.num
							arr[@state.variant][j].anses.push action.payload.value
					@setState allProblems: arr
				when "NEW_TRUE_ANSWER"
					_arr = @state.allProblems
					
					_arr[@state.variant][action.payload.no].trueanses = [action.payload.value]
					@setState allProblems: _arr
	saveTest: ->
		dispatcher.dispatch
			type: "SAVE_TEST"
			payload: {
				type_test: "edit"
				data: {
					name: @state.initData.nameTest,
					subject: @state.initData.subjectTest,
					time: @state.initData.timeTest,
					variants: @state.allProblems
				}
				id: @props.data._id
			}

	componentWillReceiveProps: (newProps)->
		arrAllProblems = newProps.data
		@setState data: arrAllProblems, allProblems: newProps.data.variants

	initValue: (node)->
		_node = React.findDOMNode node
		if _node? and @state.data?
			switch _node.name
				when "nameTest"
					_node.value = @state.data.name
				when "timeTest"
					_node.value = @state.data.time
				when "subjectTest"
					_node.value = @state.data.subject
	changeInitData: (e)->
		key = e.key
		obj = @state.initData
		type = e.target.name
		value = e.target.value
		if key == "Enter"
			switch type
				when "nameTest"

					# checking!

					obj[type] = value
					objMAINData = @state.data
					objMAINData.name = value
					@setState initData: obj, data: objMAINData
				when "timeTest"
					value = +value
					if value < 14400 and value > 0
						obj[type] = value
						objMAINData = @state.data
						objMAINData.time = value
						@setState initData: obj, data: objMAINData
					else
						alert "time has the next data: time > 0 and time < 14400"
						value = @props.data.time
						obj[type] = value
						objMAINData = @state.data
						objMAINData.time = value
						@setState initData: obj, data: objMAINData
	changeSubject: (e)->
		value = e.target.value
		type = e.target.name
		obj = @state.initData
		obj[type] = value
		objMAINData = @state.data
		objMAINData.subject = value
		@setState initData: obj, data: objMAINData
	handleAddVariant: ->
		if Object.keys(@state.initData).length >= 3
			if @state.initData.nameTest.length > 5 and (@state.initData.timeTest > 60 and @state.initData.timeTest < 14400)
				@setState addedVariant: true
			else
				alert "Введите данные корректно!"
		else
			alert "Вы ввели не все данные, введите их полнотью и продолжайте"
	handleChangeVariant: (e, _value)->
		if _value?
			console.log "_value", _value
			@setState variant: _value
		else
			value = +e.target.value
			@setState variant: value
	handleAddNewVariant: ->
		arr = @state.data
		arr.variants.push []
		_value = arr.variants.length - 1
		@setState data: arr, variant: _value
		dispatcher.dispatch
			type: "CHANGE_VALUE_SELECT_VARIANT",
			payload: _value
		
		@handleChangeVariant null, _value
	initVariant: (node)->
		_node = React.findDOMNode node
		if _node?
			value_node = _node.value
			value_variant = @state.variant
			if value_node != value_variant
				_node.value = value_variant

	render: ->
		@state.count_reload_render++
		<div className={"animFadeInDown " + @props.classItem}>
			<span className="_id_forEdit">
				{if @state.data? and @state.data.length != 0 then @state.data._id}
			</span>
			<div className="initDataTest">
				<input type="text" 
					onKeyDown={(e) => @changeInitData e} 
					ref={
						(node) => 
							@initValue node
							@nameTestInput = node
					} 
					className="data_add_test" id="nameTest" name="nameTest" placeholder="Name Test"
				/><br />

				<input type="number" 
					onKeyDown={(e) => @changeInitData e} 
					ref={(node) => 
							@initValue node
							@timeTestInput = node
					} 
					className="data_add_test" id="timeTest" name="timeTest" placeholder="Time Test"
				/><br/>

				<select name="subjectTest" onChange={(e) => @changeSubject e} className="subject" 
					ref={
						(node) => 
							@initValue node
							@subjectTestInput = node
					}
				>
					<option value="Информатика">Информатика</option>
					<option value="История">История</option>
					<option value="Математика">Математика</option>
				</select>
			</div>
			<hr />

			<div className="addVariantBlock">

				<div className="addVariantNext">

					<div className="wrp_df">
						<select 
							className="choiceVariant" 
							onChange={(e) => @handleChangeVariant e} 
							ref={
								(node) =>
									@initVariant node
							}
						>
							{
								if @state.data? and @state.data.variants.length > 0
									@state.data.variants.map (i, j)=>
										<option value={j}>{j + 1} вариант</option>
							}
						</select>
						<button onClick={@handleAddNewVariant} className="addVariantButton defButtonWithText" data-title="addVariant">+</button>
					</div>
				</div>


				
				<div className="addProblemNext">
					<div className="allProblems">
						{
							if @state.allProblems.length > 0
								if @state.allProblems[@state.variant].length > 0
									@state.allProblems[@state.variant].map (i, j) =>
										switch i.type
											when "defQ"
												<DefQ data={i} num={j}/>
											else
												<div>...</div>
							else
								"Создайте новое задание"
						}
					</div>

					<div className="formForNewProblem">
						<select className="choiceTypeProblem" ref={(node) => @tmpTypeProblem = node}>
							<option value="defQ">defQ</option>
							<option value="InpQ">InpQ</option>
							<option value="joinQ">joinQ</option>
							<option value="multiQ">multiQ</option>
						</select>
						<input type="text" placeholder="Ask..."  ref={(node) => @tmpAskProblem = node}/>
						<button className="addProblemButton defButton" onClick={@addAnsToProblems}>addProblem</button>
					</div>
				</div>

			</div>
			<button onClick={@saveTest} className="defButton saveTest">Сохранить</button>
		</div>
	componentDidMount: ->
		if @state.data? and @state.data.name != ""
			@initValue @nameTestInput
			@initValue @timeTestInput
			@initValue @subjectTestInput

module.exports = AddTest