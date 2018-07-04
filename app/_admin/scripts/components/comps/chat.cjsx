React = require "react"




Chat = React.createClass
	displayName: "ChatPanel"
	getInitialState: ->
		top_panel_state: false
		top_panel_text: "Привет участникам соревнований!" # Изменить в будущем
	changeStateChat_sub: (e)->
		console.log e.target.nodeName
		@setState top_panel_state: !@state.top_panel_state if e.target.nodeName == "SPAN" or e.target.nodeName == "P"
	changeStateChat: (e)->
		if e.key == "Enter"
			console.log e.target.value
			@setState top_panel_state: !@state.top_panel_state
			@setState top_panel_text: e.target.value
	hideMainCnt: (e)->
		n = e.target.attributes[1].value
		$("#wrp_cnt#{n}").toggle("active")
	render: ->
		<div className="chatPanel">
			<h1 className="welcome_chat_panel">
				Управление чатом
			</h1>

			<div className="block_chat animFadeInUp">
				<div className="title_block">
					<h3 className="title_block_text">Изменение приветсвенного окна чата<i onClick={(e) => @hideMainCnt e} className="fas fa-chevron-down" data-block="0"></i></h3>
				</div>
				<div className="wrp_cnt" id="wrp_cnt0">

					<div className="fixed_top_panel">
						<p className="text-center" id="changeStateChat" onClick={(e) => @changeStateChat_sub e}>{if !@state.top_panel_state then <span id="changeStateChatText">{@state.top_panel_text}</span> else <input onKeyDown={(e) => @changeStateChat e} placeholder={@state.top_panel_text}/>}</p>
					</div>
				
				</div>
			</div>


			<div className="block_chat animFadeInUp">
				<div className="title_block">
					<h3 className="title_block_text">Изменение приветсвенного окна чата<i onClick={@hideMainCnt} className="fas fa-chevron-down"></i></h3>
				</div>
				<div className="wrp_cnt">

				
				
				</div>
			</div>

		</div>


		
module.exports = Chat