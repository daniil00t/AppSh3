React = require "react"
ee = require "../../ee"

Header = React.createClass
	displayName: "Header"
	handleClickLogout: ->
		ee.emit "logoutAdmin", type: on
	render: ->
		<div className="Header_panel">
			<div className="fr">
				<ul>
					<li className="settings"><i className="fa fa-cogs"></i>Настройки</li>
					<li className="logout" onClick={@handleClickLogout}><i className="fa fa-sign-out"></i>Выйти</li>
				</ul>
			</div>
		</div>


		
module.exports = Header