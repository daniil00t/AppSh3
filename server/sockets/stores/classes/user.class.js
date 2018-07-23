// Base class user
export default class User{
	constructor(){
		this.clients = [];
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
}