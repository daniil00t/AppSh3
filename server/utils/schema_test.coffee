mongoose = require "mongoose"

Schema = mongoose.Schema

TestSchema = new Schema({
	type      : { type: String },
	title     : { type: String },
	num       : { type: Number },
	question  : { type: String },
	anses     : { type: Array },
	score     : { type: Number }
	trueanses : { type: Number }
})
module.exports = mongoose.model('Test', TestSchema)
