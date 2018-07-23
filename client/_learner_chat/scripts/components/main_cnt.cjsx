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
		# else
		# 	if val == "Enter" and e.shiftKey

	render: ->
		<div className="main_cnt">
			<div className="container">
				<div className="massages">
					<div className="fixed_top_panel"><p>{@props.hello}</p></div>
					<div className="wrp_massages">
						{
							@props.massages.map (i, j)=>
								if i.id == @props.mydata.id
									<MyMassage text={i.massage}/>
								else
									<Massage srcUrlImg={i.pathAva} name={i.nameUsr} massage={i.massage}/>
						}
					</div>

				</div>
				<div className="bottom_panel">
					<textarea rows="5" cols="70" placeholder="Pishi zdes'!" id="addMassage" onKeyDown={(e) => @addMassage e}/>
					<div className="panel_icon">
						<div className="smile_icon icon">
							<i className="fas fa-paperclip"></i>
						</div>
						<div className="clip_icon icon">
							<i className="far fa-smile"></i>
						</div>﻿
					</div>
				</div>
				<footer className="main_footer">
					<p className="text-center">Daniil Shenyagin&copy;2018 - @projectsSchool#3 - Murom</p>
				</footer>
			</div>
		</div>

module.exports = Main