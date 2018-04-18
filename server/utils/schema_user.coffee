mongoose = require "mongoose"

Schema = mongoose.Schema

UserSchema = new Schema({
	login     : { type: String },
	password  : { type: String },
	hash      : { type: String },
	privelegs : { type: String }
})

module.exports = mongoose.model('User', UserSchema)
