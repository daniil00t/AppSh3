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
	handleHoverOver: (i)->
		document.getElementsByClassName("infoUser")[i].classList.remove "_noactive"
		document.getElementsByClassName("infoUser")[i].classList.add "_active"
	handleHoverOut: (i)->
		document.getElementsByClassName("infoUser")[i].classList.remove "_active"
		document.getElementsByClassName("infoUser")[i].classList.add "_noactive"
	handleClickDeleteUser: (k)->
		mas = prompt("Massage: ")
		if mas?
			ee.emit "deleteUserAndMassage_ee", {ip: k.ip, id: k.id, massage: if mas.length is 0 then "sorry, but you are deleting" else mas}
			arr = @state.users
			for i, j in arr
				if i.id is k.id
					arr.splice j, 1
			@setState users: arr
	renderedLiUser: (i, j)->
		<li className="animFadeInUp">
			<div className="infoUser">
				<span className="labels">
					<span>id: </span><br/>
					<span>ip: </span>
				</span>
				<span className="values">
					<span>{i.id}</span><br/>
					<span>{i.ip}</span>
				</span>
			</div>
			{
				if i.fname? and i.lname?
					"#{i.fname[0].toUpperCase()}. #{i.lname}"
				else
					if i.name?
						i.name
					else 
						i.id
			}
			<span className="appUsers">{i.app}</span>
			<i className="fa fa-info-circle info" onMouseOver={@handleHoverOver.bind(@, j)} onMouseOut={@handleHoverOut.bind(@, j)}></i>
			<i className="fa fa-times-circle close" onClick={@handleClickDeleteUser.bind(@, i)}></i>
		</li>
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
									@renderedLiUser(i, j)
							when "test"
								@state.users.map (i, j)=>
									if i.app == "test"
										@renderedLiUser(i, j)
							when "chat"
								@state.users.map (i, j)=>
									if i.app == "chat"
										@renderedLiUser(i, j)
					else
						<span>Что-то пусто тут! Даже никто не заходит на мои странички!</span>
				}
			</ul>
		</div>


		
module.exports = Users_panel