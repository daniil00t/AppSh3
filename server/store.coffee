class Admin
	setAdmin: (data)->
		@_store.admin = data
	getAdmin: ->
		@_store.admin
	getAdminOnline: ->
		return if Object.keys(@getAdmin()).length == 0 then no else on
	deleteAdmin: ->
		@_store.admin = {}

class Clients extends Admin
	constructor: ()->
		@_store = {}
		@_store.clients = []
		@_store.admin = {}
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
	updateClient: (id, data)->
		console.log "update..."
		for i, j in @_store.clients
			if i.id == id
				tmp = Object.assign {}, @_store.clients[j]
				tmp[Object.keys(data)[0]] = data[Object.keys(data)[0]]
				@_store.clients[j] = tmp
	getClients: ->
		return @_store.clients
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


class Store extends Clients
	
module.exports = Store