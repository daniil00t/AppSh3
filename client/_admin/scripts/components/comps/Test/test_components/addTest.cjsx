React = require "react"

AddTest = React.createClass
	displayName: "AddTest"

	render: ->
		<div>
			<input type="text" id="nameTest" name="nameTest"/><br />
			<input type="number" id="timeTest" name="timeTest"/><br/>
			<select name="subject">
				<option value="Информатика">Информатика</option>
				<option value="История">История</option>
				<option value="Математика">Математика</option>
			</select>
			<br/>
			<button>Add variant</button>
			<div className="addVariant">
				
			</div>
		</div>


module.exports = AddTest