React = require "react"
ee = require "../../ee"

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
		console.log k
		mas = prompt("Massage: ")
		if mas?
			ee.emit "deleteUserAndMassage_ee", {ip: k.ip, id: k.id, massage: if mas.length is 0 then "sorry, but you are deleting" else mas}
			arr = @state.users
			for i, j in arr
				if i.id is k.id
					arr.splice j, 1
			@setState users: arr
	renderedLiUser: (i, j)->
		listToollipsDone = ["id", "ip", "variant", "testing"]
		listToollipsFuture = []
		for key, value of i
			for k in listToollipsDone
				if key == k
					listToollipsFuture.push k

		defLi = <li className="animFadeInUp">
			<div className="infoUser">
				<table>
						{
							listToollipsFuture.map (r, t)=>
								<tr>
									<td className="names">{r}: </td>
									<td>{if typeof i[r] == "boolean" then (if i[r] then "true" else "false") else i[r] }</td>
								</tr>
						}
				</table>

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
		testLi = <li className="animFadeInUp">
			<div className="infoUser">
				<table>
						{
							listToollipsFuture.map (r, t)=>
								<tr>
									<td className="names">{r}: </td>
									<td>{if typeof i[r] == "boolean" then (if i[r] then "true" else "false") else i[r] }</td>
								</tr>
						}
				</table>

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
			<span className="scoreUser" style={backgroundColor: if i.testing then (if i.points < 40 then "#e14040" else (if i.points > 40 and i.points < 81 then "#2196F3" else "#4caf50")) else "#eeeeee"}>{i.points}%</span>
			<i className="fa fa-info-circle info" onMouseOver={@handleHoverOver.bind(@, j)} onMouseOut={@handleHoverOut.bind(@, j)}></i>
			<i className="fa fa-times-circle close" onClick={@handleClickDeleteUser.bind(@, i)}></i>
		</li>

		
		switch @state.filtered
			when "test"
				testLi
			else
				defLi
	

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
					if @props.users.length > 0
						switch @state.filtered
							when "all"
								@props.users.map (i, j)=>
									@renderedLiUser(i, j)
							when "test"
								@props.users.map (i, j)=>
									if i.app == "test"
										@renderedLiUser(i, j)
							when "chat"
								@props.users.map (i, j)=>
									if i.app == "chat"
										@renderedLiUser(i, j)
					else
						<span>Что-то пусто тут! Даже никто не заходит на мои странички!</span>
				}
			</ul>
		</div>


		
module.exports = Users_panel