import socket from "socket.io";
import { EventEmitter } from "events";
import URL from "url";

import MainStore from "./stores/store";




/*
	Подключние функций socket-client каждого приложения
*/
import chat from "./apps/chat.socket";
import test from "./apps/test.socket";
import admin from "./apps/admin.socket";

/*
	MainSock - это класс, включающий в себя все основные свойства и функции сокет-клиента
	1. Connection
	2. Switch - разделяется на пути (/learner/chat)
	3. Disconnect
*/

class MainSock {
	constructor(){
		this.store = new MainStore();
	}
	connect(io, db){
		// sock.watching();
		let self = this;
		io.on("connection", (_socket) => {
			let urlpath = URL.parse(_socket.handshake.headers.referer).pathname;
			if(urlpath[urlpath.length - 1] == "/"){
				var app = urlpath.split("/")[urlpath.split("/").length-2];
			}
			else{
				var app = urlpath.split("/")[urlpath.split("/").length-1];
			}
			console.log(app);
			switch(app){
				case "chat":{
					
					// socket ONs' ChatApp
					chat(_socket, self.store);
					self.disconnect(_socket);
				}break;
				case "test": {

					// socket ONs' ChatApp
					test(_socket, self.store, db);
					self.disconnect(_socket);
				}break;
				case "admin": {

					// socket ONs' ChatApp
					admin(_socket, self.store, db);

				}break;
				default:{
					throw Error("undefined path");
				}
			}
			
			return _socket;
		});
	}
	disconnect(_socket){
		let self = this;
		// отключение клиента
		_socket.on("disconnect", (data) => {
			let id = _socket.id;
			console.log(`disconnect user, id: ${id}`)
			// self.store.addUserToData(id);
			self.store.deleteClient(id);
		});
	}
	getStore(){
		return this.store;
	}
}


export function initSocket (server, db) {

	const sock = new MainSock("hello!");

	const io = socket(server);
	sock.connect(io, db);

	return sock.getStore()
}


