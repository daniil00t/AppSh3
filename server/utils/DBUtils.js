import mongoose from "mongoose";

import config from '../../etc/config.json';

import '../models/test.model';

const Test = mongoose.model('Test');

export function setUpConnection() {
  mongoose.connect(`mongodb://${config.db.host}:${config.db.port}/${config.db.name}`);
}

export function listTests(id) {
  return Test.find();
}