React = require "react"

Item = React.createClass
	displayName: "ItemBlock"
	getInitialState: ->
		stateBlock: true

	changeStateBlock: ->
		@setState stateBlock: !@state.stateBlock
	componentWillMount: ->
		# console.log @props


	render: ->
		<div className="block_chat animFadeInUp">
			<div className="title_block">
				<h3 className="title_block_text">{@props.title}<i onClick={@changeStateBlock} className="fas fa-chevron-down" data-block="0"></i></h3>
			</div>

			<div className="wrp_cnt" style={{display: if @state.stateBlock then "block" else "none"}}>
			
				{
					@props.children
				}

			</div>
		</div>

module.exports = Item