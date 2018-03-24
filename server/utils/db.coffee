mongoose = require "mongoose"
fs = require "fs"
path = require "path"

setUpConnection = ->
	console.log "Connecting..."
	data = fs.readFileSync path.resolve(__dirname, "../etc/config.json"), "utf-8"
	config = JSON.parse data
	mongoose.connect "mongodb://#{config.db.host}:#{config.db.port}/#{config.db.name}", (err)->
		if err then console.log "connection failed=(" else console.log "Ok"
	
	


# export function listNotes(id) {
#     return Note.find();
# }

# export function createNote(data) {
#     const note = new Note({
#         title: data.title,
#         text: data.text,
#         color: data.color,
#         createdAt: new Date()
#     });

#     return note.save();
# }

# export function deleteNote(id) {
#     return Note.findById(id).remove();
# }

module.exports = {setUpConnection: setUpConnection}