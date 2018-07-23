// import { EventEmitter } from "events";
// import Dispatcher from "./dispatcher";
import User from "./classes/user.class";
import Chat from "./classes/chat.class";

export default class MainStore extends Chat(User) {  
	constructor(){
		// Chat(User)
		//  ^
		// Смотрим на последний родительский класс и вызываем super данного класса с аргументом конструктора этого родительского класса и т.п.
		super("Hello");
	}
}