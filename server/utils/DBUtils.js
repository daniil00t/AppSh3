import mongoose from "mongoose";

import config from '../../etc/config.json';

import '../models/test.model';
import '../models/user.model';

const Test = mongoose.model('Test');
const User = mongoose.model('User');

export function setUpConnection() {
	mongoose.connect(`mongodb://${config.db.host}:${config.db.port}/${config.db.name}`)
		.catch((err) => {
			console.log("Error: " + err.name);
		});


}
/*
	User Model
*/
export function listUsers(id) {
  return User.find();
}


/*
	Test Model
*/
export function listTests(id) {
  return Test.find();
}
export function addTest(data){
	Test.create(data, err => {
		if(err) throw err;
		console.log("saved -> OK")
	})
}

export function updateTest(id, news){
	Test.findByIdAndUpdate(id, { $set: news }, { new: true }, (err, doc) => {
		if(err) throw err;
		console.log(doc);
	});
}
export function removeTest(id){
	Test.remove({ _id: id }, (err) => {
		if(err) throw err;
		console.log(id + " - removed");
	})
}