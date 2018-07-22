// import { EventEmitter } from "events";
// import Dispatcher from "./dispatcher";

export default class MainStore{
	constructor(chatHello = "hello"){
		this.clients = [];
		this.chat_hello = chatHello;
	}
	getClients(){
		return this.clients;
	}
	addClient(data){
		this.clients.push(data);
		// Dispatcher.dispatch({
		// 	type: "ADD_USER",
		// 	payload: data
		// });
	}
	updateClient(id, data){
		this.clients.map((i, j) => {
			if(i.id == id){
				for(let l in data){
					this.clients[j][l] = data[l];
				}
			}
		});
		console.log(this.getClients());
		return this.getClients();
	}
	deleteClient(id){
		let self = this;
		this.clients.map((i, j) => {
			if(i.id == id){
				self.clients.splice(j, 1);
			}
		});
		console.log(this.getClients());
		return this.getClients();
	}
	updateChatHello(value){
		this.chat_hello = value;
	}
	getChatHello(){
		return this.chat_hello;
	}
}