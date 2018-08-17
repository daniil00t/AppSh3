React = require "react"

Notification = React.createClass
	displayName: "Notification"
	getInitialState: ->
		visible: false
	componentWillReceiveProps: (newProps)->
		@setState visible: newProps.visible
	# Main methods
	handleClose: ->
		@setState visible: false

	# Local methods
	handleEnterPrompt: ->
		console.log React.findDOMNode(@promptInput).value
	handleChangeConfirm: (success)->
		if success
			console.log "confirm - yes"
		else
			console.log "confirm - no"
	render: ->
		<div className="Notification animFadeInDown" style={{opacity: (if @state.visible then "1" else "0"), display: (if @state.visible then "block" else "none")}}>
			
			<div className="nf_wrp">
				<i className="fas fa-times-circle close" onClick={@handleClose}></i>
				{
					switch @props.type
						when "massage"
							<div className="massage">
								<span className="tag">massage</span><br/>
								<p className="massage_title">{@props.data.massage}</p>
								<button className="button_success" onClick={@handleClose}>Ok</button>
							</div>
						when "prompt"
							<div className="prompt">
								<span className="tag">prompt</span><br/>
								<span className="prompt_title">{@props.data.title}</span>
								<input type={@props.data.typeInput} placeholder={if @props.data.ph? then @props.data.ph} ref={(node) => @promptInput = node}/>
								<button className="button_success" onClick={@handleEnterPrompt}>Enter</button>
							</div>
						when "confirm"
							<div className="prompt">
								<span className="prompt_title">{@props.data.question}</span>
								<button className="button_success" onClick={@handleChangeConfirm false}>Cancel</button>
								<button className="button_success" onClick={@handleChangeConfirm true}>Ok</button>
							</div>
				}
				</div>
		</div>

module.exports = Notification