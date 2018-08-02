import dispatcher from "../stores/dispatcher";

export default function(socket, store, db){
	dispatcher.register(action => {
		switch(action.type){
			case "CONNECT_USER":
			case "UPDATE_USER": 
			case "DISCONNECT_USER":
			case "UPDATE_ANSWER_USER":{
				socket.emit(action.type, {payload: action.payload})
			}break;
			default: {
				console.log("Problem...");
			}
		}
	})
}