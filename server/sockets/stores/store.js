// import { EventEmitter } from "events";
// import Dispatcher from "./dispatcher";
import User from "./classes/user.class";
import Chat from "./classes/chat.class";
import Test from "./classes/test.class";

import dispatcher from "./dispatcher";



export default class MainStore extends Test(Chat(User)) {  
	constructor(){
		// Test(Chat(User))
		//  ^
		// Смотрим на последний родительский класс и вызываем super данного класса с аргументом конструктора этого родительского класса
		super();
	}
}