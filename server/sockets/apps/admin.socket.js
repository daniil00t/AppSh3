import dispatcher from "../stores/dispatcher";

export default function(socket, store, db){
	function getTests() {
	  return db.listTests();
	}
	async function getTrueAnses() {
	  const tests = await getTests()
	  let trueAnses = []

	  console.log(tests)
	  // Перебор всех тестов
	  tests.map((i, j) => {
	  	// Перебор вариантов
	  	let TAvariants = []
	  	i.variants.map((k, l) => {
	  		// Перебор заданий
	  		let TAproblems = []
	  		k.map((q, w) => {
	  			TAproblems.push({
	  				no: w,
	  				value: q.trueanses,
	  				type: q.type,
	  				score: q.score
	  			})
	  		})
	  		TAvariants.push(TAproblems)
	  	})
	  	trueAnses.push({id: i._id, data: TAvariants})
	  })
		return trueAnses;
	}

	// Достаем правильные ответы из БД
	getTrueAnses()
		.then(data => {
		  socket.emit("init", {type: "data_true_anses", data: data})
		})
		.catch((err) => {
			console.error(err)
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
			case "CHANGE_APP_STATE": {
				dispatcher.dispatch(data)
			}break;
			default: {
				console.log("problem..")
			}
		}
	})
}