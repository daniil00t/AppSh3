ee = require "./ee"

class Chat
	constructor: (hello, count_users) ->
		@hello = hello
		@count_users = count_users
	getHello: ->
		@hello
	changeHello: (cnt)->
		console.log "hello chat chenched!"
		@hello = cnt
		ee.emit "changeHello_chat@ee", cnt: cnt

module.exports = Chat