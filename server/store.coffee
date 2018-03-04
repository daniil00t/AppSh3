class Store
	constructor: ()->
		@_store = {}
		@_store.clients = []
		@_store.configs = {}
	addNewClient: (data)->
		@_store.clients.push data
	addContent: (id, data)->
		for i, j in @_store.clients
			if i.id?
				if id == i.id
					@_store.clients[j]["content"] = data
	getClient: (id)->
		for i in @_store.clients
			if id == i.id
				return i
	getClients: ->
		@_store.clients
	deleteClient: (id)->
		try
			j = 0
			if @_store.clients != 1
				for i in @_store.clients
					if id is i.id
						@_store.clients.splice j, 1
					j++
			else:
				@_store.clients = []
		catch
			console.log id


module.exports = Store