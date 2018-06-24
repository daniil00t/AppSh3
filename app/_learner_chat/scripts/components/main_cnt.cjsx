React = require "react"

MyMassage = require "./my_massage"
Massage = require "./massage"
ee = require "../ee"


Main = React.createClass
	displayName: "Main_cnt"

	addMassage: (e)->
		val = e.key
		if val == "Enter" and !e.shiftKey
			massage = e.target.value
			# Очищаем textarea
			document.getElementById(e.target.id).value = ""
			e.preventDefault()
			ee.emit "addMassage__toHeader", {massage: massage}
	render: ->
		<div className="main_cnt">
			<div className="container">
				<div className="massages">
					
					

				</div>
				<div className="bottom_panel">
					<textarea rows="5" cols="70" placeholder="Pishi zdes'!" id="addMassage" onKeyDown={(e) => @addMassage e}/>
					<div className="panel_icon">
						<div className="smile_icon">
						</div>
						<div className="clip_icon">

						</div>﻿
					</div>
				</div>
			</div>
		</div>

module.exports = Main