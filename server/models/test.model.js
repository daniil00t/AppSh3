import mongoose from "mongoose";

const Schema = mongoose.Schema;

const TestSchema = new Schema({
	name			: { type: String },
	subject		: { type: String },
	time			: { type: Number },
	variants  : { type: Array }
});

export default mongoose.model('Test', TestSchema);