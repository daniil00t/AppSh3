React = require "react"
ee = require "../ee"

Avatars = [
	["admin", "/imgFiles/avatars/admin.jpg"],
	["daniil", "/imgFiles/avatars/admin.jpg"],
	# ["Daniil", "/imgFiles/avatars/danill.png"]
]
###
	parseValue ("{{admin}}", arr)  -->  "/imgFiles/avatars/admin.png"
###
parseValue = (val)->

	_val = val.replace( /\{\{(\w*)\}\}/g, (match, $1)->
		return $1
	)
	console.log _val
	ans = null
	for i in Avatars
		if i[0] == _val
			ans = i[1]
			break
	if ans? then ans else _val

Header = React.createClass
	displayName: "Header"
	getInitialState: ->
		ava: false
		nameUsr: ""
		defaultPathImgUsr: "/imgFiles/no-avatar.png"
		pathImgUsr: ""
	haveAva: (e)->
		if e.target.checked
			@setState ava: true
			$(".out").removeClass("noactive").addClass("active")
		else
			@setState ava: false
			$(".out").removeClass("active").addClass("noactive")
	changeNameUsr: ->
		name = document.getElementById("name").value
		if name.length > 3
			ee.emit "changeNameUsr@ee", name: name
			@setState nameUsr: name
		else
			alert "Введите имя корректно!"
	changeNameUsrForInput: (e)->
		val = e.key
		if val == "Enter"
			name = e.target.value
			if name.length > 3
				ee.emit "changeNameUsr@ee", name: name
				@setState nameUsr: name
			else
				alert "Введите имя корректно!"

	changePathImgUsr: (e)->
		val = e.key
		if val == "Enter"
			path = e.target.value
			path = if parseValue(path)? then parseValue(path) else @state.defaultPathImgUsr
			ee.emit "changePathImgUsr@ee", path: path
			@setState pathImgUsr: path
			# console.log 
	componentWillMount: ->
		ee.on "addMassage__toHeader", (data)=>
			ee.emit "addMassage", {massage: data.massage, nameUsr: @state.nameUsr, pathAva: if @state.pathImgUsr != "" then @state.pathImgUsr else @state.defaultPathImgUsr}
	render: ->
		<header className="chat_header">
			<div className="container-fluid">
				<div className="row">
					<div className="col-md-3 col-lg-3">
						<div className="logo">
							<a href="/learner/chat"><img src="/imgFiles/logo_chat.png" /></a>
						</div>
					</div>
					<div className="col-md-6 col-lg-6 main_part_header">
						<div className="changeNameUser">
							<input type="text" id="name" placeholder="Name.." onKeyDown={(e) => @changeNameUsrForInput e}/><br />
							<button className="btn btn-default save_name" onClick={@changeNameUsr}>Save</button>
						</div>
						<div className="changeAva">
							<label for="ava" style={display: if @state.ava then "none" else "block"}>
								<input name="ava" id="ava" type="checkbox" onChange={(e) => @haveAva e} disabled={if @state.nameUsr != "" then "" else "disabled"}/>
							У меня есть ава</label><br/>
							<div className="out noactive">
								<div className="ava_wrp_img">
									<img src={(if @state.pathImgUsr != "" then @state.pathImgUsr else @state.defaultPathImgUsr)}/>
								</div>
								<input type="text" id="url" onKeyDown={(e) => @changePathImgUsr e} placeholder="Url.." />
							</div>
						</div>
						
					</div>
					<div className="col-md-3 col-lg-3 menu-left">
						<a className="btn btn-default logout_button" href="/learner"><i className="fas fa-sign-out-alt"></i>Выйти</a>
					</div>
				</div>
			</div>
		</header>


module.exports = Header