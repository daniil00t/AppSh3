React = require "react"

dispatcher = require "../test.dispatcher"

DefQ = require "./defQ"
# MultQ = require "./multQ"
# JoinQ = require "./joinQ"
# InpQ = require "./inpQ"

AddTest = React.createClass
	displayName: "AddTest"
	getInitialState: ->
		addedVariant: false
		addedProblem: false
		focusNow: "nameTest"
		initData: {subject: "Информатика"}
		variant: 0
		# tmpProblems - массив тестов одного вариатна
		allProblems: [[]]
	addAnsToProblems: ->
		obj = {type: React.findDOMNode(@tmpTypeProblem).value, question: React.findDOMNode(@tmpAskProblem).value, anses: [], num: @state.allProblems[@state.variant].length, score: 1, trueanses: []}
		React.findDOMNode(@tmpAskProblem).value = ""
		arr = @state.allProblems
		arr[@state.variant].push obj
		@setState allProblems: arr
	componentWillMount: ->
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
				type_test: "add"
				data: @state.allProblems,
				initData: @state.initData
			}

	focusInput: (node)->
		_node = React.findDOMNode(node) # returned <input />
		if _node?
			_node.focus()
	changeInitData: (e)->
		key = e.key
		obj = @state.initData
		type = e.target.name
		value = e.target.value
		if key == "Enter"
			switch type
				when "nameTest"
					obj[type] = value
					@setState initData: obj
					@setState focusNow: "timeTest"
				when "timeTest"
					obj[type] = +value
					@setState initData: obj
					@setState focusNow: "subjectTest"
	changeSubject: (e)->
		value = e.target.value
		type = e.target.name
		obj = @state.initData
		obj[type] = value
		@setState initData: obj
	handleAddVariant: ->
		if Object.keys(@state.initData).length >= 3
			if @state.initData.nameTest.length > 5 and (@state.initData.timeTest > 60 and @state.initData.timeTest < 14400)
				@setState addedVariant: true
			else
				alert "Введите данные корректно!"
		else
			alert "Вы ввели не все данные, введите их полнотью и продолжайте"
	handleAddNewVariant: ->
		arr = @state.allProblems
		arr.push []
		value = @state.variant + 1
		@setState allProblems: arr, variant: value
	changeVariant: (e)->
		value = +e.target.value # return num -> 1
		@setState variant: value
	initVariant: (node)->
		_node = React.findDOMNode node
		if _node?
			value_node = _node.value
			value_variant = @state.variant
			if value_node != value_variant
				_node.value = value_variant
	render: ->
		<div className={"animFadeInDown " + @props.classItem}>
			<div className="initDataTest">
				<input type="text" 
					onKeyDown={(e) => @changeInitData e} 
					ref={
						(node) =>
							if @state.focusNow == "nameTest"
								@focusInput node
					} 
					className="data_add_test" id="nameTest" name="nameTest" placeholder="Name Test"
				/><br />
				<input type="number" onKeyDown={(e) => @changeInitData e} ref={(node) => if @state.focusNow == "timeTest" then @focusInput node} className="data_add_test" id="timeTest" name="timeTest" placeholder="Time Test"/><br/>
				<select name="subject" onChange={(e) => @changeSubject e} className="subject" ref={(node) => if @state.focusNow == "subjectTest" then @focusInput node}>
					<option value="Информатика">Информатика</option>
					<option value="История">История</option>
					<option value="Математика">Математика</option>
				</select>
			</div>
			<hr />

			<button className="addVariantButton defButton" onClick={@handleAddVariant} style={{display: if @state.addedVariant then "none" else "block"}}>addVariant</button>
			
			<div className="addVariantBlock"  style={{display: if @state.addedVariant then "block" else "none"}}>

				<div className="addVariantNext" style={{display: if @state.addedVariant then "block" else "none"}}>

					<div className="wrp_df">
						<select className="choiceVariant" onChange={(e) => @changeVariant e} ref={(node) => @initVariant node}>
							{
								@state.allProblems.map (i, j)=>
									<option value={j}>{j+1} вариант</option>
							}
						</select>
						<button onClick={@handleAddNewVariant} className="addVariantButton defButtonWithText" data-title="addVariant">+</button>
					</div>
				</div>


				
				<div className="addProblemNext">
					<div className="allProblems">
						{
							# improve
							if @state.allProblems.length != 0
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
			<button onClick={@saveTest} className="defButton saveTest">Создать</button>
		</div>


module.exports = AddTest