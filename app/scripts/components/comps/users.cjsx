React = require "react"
ee = require "../../ee"

# <li>Daniil Shenyagin<i className="fa fa-info-circle info"></i><i className="fa fa-times-circle close"></i></li>
# 				<li>Audrey Subbotin<i className="fa fa-info-circle info"></i><i className="fa fa-times-circle close"></i></li>
# 				<li>Sergey Missurin<i className="fa fa-info-circle info"></i><i className="fa fa-times-circle close"></i></li>
options = [
	"all"
	"test"
	"chat"
]
Users_panel = React.createClass
	displayName: "Users"
	getInitialState: ->
		users: []
		filtered: "all"
	handleChangeFiltered: (e)->
		@setState filtered: e.target.value
	renderedLiUser: (i)->
		<li>{if i.name? then i.name else i.id}<span className="appUsers">{i.app}</span><i className="fa fa-info-circle info"></i><i className="fa fa-times-circle close"></i></li>
	componentWillMount: ->
		ee.emit "loadUsers", status: "load"
		ee.on "loadUsers", (data)=>
			arr = []
			if data.status == "sending"
				for i in data.data
					arr.push i
				@setState users: arr

	render: ->
		
		<div className="users-settings">
			<h1>Users Online</h1>
			<select className="changeApp" onChange={(e) => @handleChangeFiltered e}>
				{
					options.map (i, j)=>
						<option value={i}>{i}</option>
				}
			</select>
			<ul className="onlineusers">
				{
					if @state.users.length > 0
						switch @state.filtered
							when "all"
								@state.users.map (i, j)=>
									@renderedLiUser(i)
							when "test"
								@state.users.map (i, j)=>
									if i.app == "test"
										@renderedLiUser(i)
							when "chat"
								@state.users.map (i, j)=>
									if i.app == "chat"
										@renderedLiUser(i)
					else
						<span>Что-то пусто тут! Даже никто не заходит на мои странички!</span>
				}
			</ul>
		</div>


		
module.exports = Users_panel