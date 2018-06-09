React = require "react"
Header = require "./components/header"


App = React.createClass
	displayName: "App"

	render: ->
		<Header />


module.exports = App