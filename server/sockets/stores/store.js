// import { EventEmitter } from "events";
// import Dispatcher from "./dispatcher";
import User from "./classes/user.class";
import Chat from "./classes/chat.class";
import Test from "./classes/test.class";

import dispatcher from "./dispatcher";

dispatcher.register((action) => {
	switch(action.type){
		case "CHANGE_CHAT_HELLO": {
			console.log("action CHANGE_CHAT_HELLO success!");
		}break;
	}
});

export default class MainStore extends Test(Chat(User)) {  
	constructor(){
		// Chat(User)
		//  ^
		// Смотрим на последний родительский класс и вызываем super данного класса с аргументом конструктора этого родительского класса и т.п.
		super();
		this.updateChatHello("Hello World!");
	}
}