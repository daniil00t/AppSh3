React = require "react"

Panel = React.createClass
	displayName: "Panel"
	render: ->
		<div className="row">
			<div className="col-md-2 col-lg-2 navbarmain">
				<div className="brand"><h1>Admin Panel</h1></div>
				<ul className="navbar">
					<li className="active">Users</li>
					<li>Tests</li>
					<li>DB</li>
					<li>Features</li>
				</ul>
			</div>
			<div className="col-md-10 col-lg-10 mainArea">
				<div className="wrp">
					<div className="users-settings">
						<h1>Users Online</h1>
						<select className="changeApp">
							<option value="test">test</option>
							<option value="chat">chat</option>
						</select>
						<ul className="onlineusers">
							<li>Daniil Shenyagin<i className="fa fa-info-circle info"></i><i className="fa fa-times-circle close"></i></li>
							<li>Audrey Subbotin<i className="fa fa-info-circle info"></i><i className="fa fa-times-circle close"></i></li>
							<li>Sergey Missurin<i className="fa fa-info-circle info"></i><i className="fa fa-times-circle close"></i></li>
						</ul>
					</div>
				</div>
			</div>
		</div>

module.exports = Panel