import dispatcher from "../stores/dispatcher";

export default function(socket, store, db){
	function getTests() {
	  return db.listTests();
	}
	async function getTrueAnses() {
	  const tests = await getTests()
	  let trueAnses = []

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
		  socket.emit("INIT", {type: "data_true_anses", data: data})
		})
		.catch((err) => {
			console.error(err)
		});
	getTests()
		.then(data => {
			socket.emit("INIT", {type: "data_tests", data: data})
		})
		.catch(err => {
			console.error(err);
		})
	socket.emit("INIT", {type: "users", data: store.getClients()})
	socket.emit("INIT", {type: "data_users", data: store.getDataUsers()})
	socket.emit("INIT", {type: "activeTest", data: store.getActiveTest()})

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

	socket.emit("INIT", {type: "chat_hello", data: store.getChatHello()})

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

	socket.on("SAVE_TEST", (data) => {
		if(data.payload.type_test == "add"){
			console.log("add...");
			db.addTest({
				name: data.payload.initData.nameTest,
				subject: data.payload.initData.subject,
				time: data.payload.initData.timeTest,
				variants: data.payload.data
			})
		} else{
			db.updateTest(data.payload.id, data.payload.data)
		}
	});

	socket.on("ACTIVE_TEST", data => {
		console.log("Change active test")
		store.setActiveTest(data.payload);
	})
}