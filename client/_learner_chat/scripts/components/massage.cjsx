React = require "react"

Massage = React.createClass
	displayName: "Massage"
	render: ->
		<div className="other_massage">
			<div className="wrp">
				<div className="info">
					<div className="wrp_img">
						<img src={@props.srcUrlImg}/>
					</div>
					<div className="name_usr">
						<span>{@props.name}</span>
					</div>
				</div>
				<div className="cnt_massage">
					<p>{@props.massage}</p>
				</div>
				<i className="fas fa-caret-left"></i>
			</div>
			<div className="text">{@props.text}</div>
		</div>

module.exports = Massage