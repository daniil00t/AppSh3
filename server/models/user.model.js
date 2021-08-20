import mongoose from "mongoose";

const Schema = mongoose.Schema;

const UserSchema = new Schema({
	login     : { type: String },
	password  : { type: String },
	hash      : { type: String },
	privelegs : { type: String }
});

export default mongoose.model('User', UserSchema);