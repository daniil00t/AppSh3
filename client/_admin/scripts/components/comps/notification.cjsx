React = require "react"

main_dispatcher = require "../../events/dispatchers/main_dispatcher"
MDC = require "../../events/constants/main_dispatcher_consts"

Notification = React.createClass
	displayName: "Notification"
	getInitialState: ->
		visible: false
		count_reload_render: 0
	componentWillReceiveProps: (newProps)->
		@setState visible: newProps.visible
	# Main methods
	handleClose: ->
		@setState visible: false

	# Local methods
	handleEnterPrompt: ->
		if React.findDOMNode(@promptInput).value == "headder"
			main_dispatcher.dispatch
				type: MDC.DELETE_TEST
				payload: @props.data.discr.id
			@setState visible: false
	handleChangeConfirm: (success)->
		if success
			console.log "confirm - yes"
		else
			console.log "confirm - no"
	handleEvent: (n)->
		if n == @state.count_reload_render
			setTimeout (=>
				@setState visible: false
			), 3000
	render: ->
		@state.count_reload_render++
		if @props.data?
			switch @props.type
				when "main"
					<div className="Notification animFadeInDown" style={{opacity: (if @state.visible then "1" else "0"), display: (if @state.visible then "block" else "none")}}>
						<div className="nf_wrp">
							<i className="fas fa-times-circle close" onClick={@handleClose}></i>
							{
								switch @props.data.type
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
				when "event"
					@handleEvent(@state.count_reload_render)
					<div className="events" style={if @state.visible then {opacity: "1", animation: "forEvent ease-in-out 3s"} else {opacity: "0", display: "none"}}>
						{
							switch @props.data.type
								when "success"
									<div className="success">
										<i className="fas fa-check"></i><span className="event_title">{@props.data.massage}</span>
									</div>
								else
									<div className="event_etc"></div>
						}
					</div>
				else
					<div></div>
		else
			<div></div>


module.exports = Notification