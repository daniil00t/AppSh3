React = require "react"

Users = require "./comps/users"
Chat = require "./comps/chat"
TestSt = require "./comps/Test/tests_st"
Test = require "./comps/Test/tests"
DB_panel = require "./comps/db"
Features = require "./comps/feature"

Header_panel = require "./comps/header_panel"

ul = [
	"Users",
	"Chat"
	"Tests_statistics"
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
		window.location.hash = ul[j]
	componentWillMount: ->
		hash = window.location.hash
		if(hash)
			_hash = hash.substr 1, hash.length-1
			console.log _hash
			for i, j in ul
				if i == _hash
					@setState sidebarvalue: j
					break
		else 
			console.log "def"
		
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
							when 2 then <TestSt users={@props.data.users.data}/>
							when 3 then <Test users={@props.data.users.data}/>
							when 4 then <DB_panel />
							when 5 then <Features />
							else <div>Help!</div>
					}
				</div>
			</div>
		</div>

module.exports = Panel