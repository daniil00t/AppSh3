import dispatcher from "../dispatcher";

// Base class user
export default class User{
	constructor(){
		this.clients = [];
	}
	getClients(){
		return this.clients;
	}
	addClient(data){
		dispatcher.dispatch({
			type: "CONNECT_USER",
			payload: data
		})
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

		dispatcher.dispatch({
			type: "UPDATE_USER",
			payload: {id: id, data: data}
		})
		
		// return this.getClients();
	}
	deleteClient(id){
		let self = this;
		this.clients.map((i, j) => {
			if(i.id == id){
				self.clients.splice(j, 1);
			}
		});

		dispatcher.dispatch({
			type: "DISCONNECT_USER",
			payload: id
		})

		console.log(this.getClients());
		return this.getClients();
	}
}