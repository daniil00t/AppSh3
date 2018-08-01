import mongoose from "mongoose";

import config from '../../etc/config.json';

import '../models/test.model';
import '../models/user.model';

const Test = mongoose.model('Test');
const User = mongoose.model('User');

export function setUpConnection() {
	try{
	  mongoose.connect(`mongodb://${config.db.host}:${config.db.port}/${config.db.name}`)
	  	.catch((err) => {
	  		console.err(err);
	  	});
	} catch(err){
		throw new Error("Невозможно подключиться к базе данных)");
	}
}

export function listTests(id) {
  return Test.find();
}
export function listUsers(id) {
  return User.find();
}


/*
	update: (schema, id, news)->
		schema.findByIdAndUpdate id, { $set: news}, { new: true }, (err, doc)->
	  if err then throw err
	  console.log doc
*/

export function updateTest(id, news){
	Test.findByIdAndUpdate(id, { $set: news }, { new: true }, (err, doc) => {
		if(err) throw err;
		console.log(doc);
	});
}