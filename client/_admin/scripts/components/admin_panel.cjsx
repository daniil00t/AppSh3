React = require "react"

Users = require "./comps/users"
Chat = require "./comps/chat"
Test = require "./comps/tests"
DB_panel = require "./comps/db"
Features = require "./comps/feature"

Header_panel = require "./comps/header_panel"

ul = [
	"Users",
	"Chat"
	"Tests"
	"DB"
	"Features"
]


Panel = React.createClass
	displayName: "Panel"
	getInitialState: ->
		sidebarvalue: 0
	handleClickSetValue: (j)->
		@setState sidebarvalue: j
	render: ->
		<div className="row">
			<div className="col-md-2 col-lg-2 col-sm-2 col-xs-2 navbarmain">
				<div className="brand"><h1>Admin Panel</h1></div>
				<ul className="navbar">
					{
						ul.map (i, j)=>
							<li onClick={@handleClickSetValue.bind(@, j)} className={if @state.sidebarvalue is j then "active" else "noactive"}>{i}</li>
					}
				</ul>
			</div>
			<div className="col-md-10 col-lg-10 col-sm-10 col-xs-10 mainArea">
				<Header_panel />
				<div className="wrp">
					{
						switch @state.sidebarvalue
							when 0 then <Users users={@props.data.users.data}/>
							when 1 then <Chat data={@props.data.chat}/>
							when 2 then <Test />
							when 3 then <DB_panel />
							when 4 then <Features />
							else <div>Help!</div>
					}
				</div>
			</div>
		</div>

module.exports = Panel