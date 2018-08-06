import dispatcher from "../stores/dispatcher";

export default function(socket, store, db){
	function getTests() {
	  return db.listTests();
	}
	async function getTrueAnses() {
	  const tests = await getTests()
	  let trueAnses = []

	  tests.map((i, j) => {
			let itemTA = {}
			itemTA.variant = j;
			itemTA.data = [];
			i.data.map((k, l) => {
				itemTA.data.push({
					no: l,
					value: k.trueanses
				})
			})
			trueAnses.push(itemTA)
		})
		return trueAnses;
	}
	// Достаем правильные ответы из БД
	getTrueAnses().then(data => {
	  socket.emit("init", {type: "data_true_anses", data: data})
	});

	socket.emit("init", {type: "users", data: store.getClients()})
	socket.emit("init", {type: "data_users", data: store.getDataUsers()})

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

	socket.emit("init", {type: "chat_hello", data: store.getChatHello()})

	socket.on("_CHANGE", (data) => {
		switch(data.type){
			case "CHANGE_CHAT_HELLO": {
				store.updateChatHello(data.data)
			}break;
			default: {
				console.log("problem..")
			}
		}
	})
}