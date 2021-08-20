React = require "react"
ee = require "../../ee"

Header = React.createClass
	displayName: "Header"
	handleClickLogout: ->
		ee.emit "logoutAdmin", type: on
	handleClickSettings: ->
		alert "В разработке... Ждите или лучше напишите разработчику"
	render: ->
		<div className="Header_panel">
			<div className="fr">
				<ul>
					<li className="settings" onClick={@handleClickSettings}><i className="fa fa-cogs"></i>Настройки</li>
					<li className="logout"><i className="fa fa-sign-out-alt"></i><a href="/logout" style={color: "white"}>Выйти</a></li>
				</ul>
			</div>
		</div>


		
module.exports = Header