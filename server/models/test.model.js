import mongoose from "mongoose";

const Schema = mongoose.Schema;

const TestSchema = new Schema({
	variant   : { type: Object },
	data      : { type: Array },
	time      : { type: Number }
});

export default mongoose.model('Test', TestSchema);