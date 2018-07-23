React = require "react"

ee = require "../../ee"

DB = React.createClass
	displayName: "Users"
	hideMainCnt: (e)->
		### !!! Переделать - не нравится, как сделано - Сделать адекватно !!! ###
		n = e.target.attributes[1].value
		$("#wrp_cnt#{n}").toggle("active")
		### !!! ###
	importDB: ->
		ee.emit "importDB@ee", type: document.getElementById("sel_db").value
	render: ->
		<div className="dbPanel">
			<h1 className="welcome_db_panel">
				Управление базой данных
			</h1>

			<div className="block_db animFadeInUp">
				<div className="title_block">
					<h3 className="title_block_text">Импорт баз данных<i onClick={(e) => @hideMainCnt e} className="fas fa-chevron-down" data-block="0"></i></h3>
				</div>
				<div className="wrp_cnt" id="wrp_cnt0">
					<select name="db" id="sel_db">
						<option value="users">users</option>
						<option value="tests">tests</option>
					</select>
					<button className="import" onClick={@importDB}>Импортировать</button>
				
				</div>
			</div>

		</div>


		
module.exports = DB