loadFile = (path)->
	request = new XMLHttpRequest()
	request.open("GET", path, true)
	request.send()
	request.onreadystatechange = ->
		if request.readyState is 4 && request.status is 200
			ans = JSON.parse request.responseText
	request	
module.exports = loadFile "/filesETC/configs.json"
