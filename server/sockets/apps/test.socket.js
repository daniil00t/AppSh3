const filterTAnses = (arr) => {
	let _arr = arr;
	_arr.map((i, j) => {
		_arr[j].data[0].trueanses = null;
	});
	return _arr;
};

export default function(socket, store, db){
	let self = this;
	let id = socket.id;
	let ip = socket.handshake.address;

	// add Client to Test stores
	store.addClient({
		id: id,
		ip: ip,
		app: "test",
		score: 0,
		points: 0,
		connected_time: new Date().getTime(),
		variant: 1,
		testing: false,
		endTest: false
	});

	console.log(`connected user, id: ${id}, ip: ${ip}`);
	socket.emit("connected", {
		id: id,
		ip: ip
	})

	db.listTests().then((data) => {
		socket.emit("getDataTest", data);
	})

	// db.removeTest("5b69a8efa4a3ad4678dad881");
	// db.updateTest("5b69a8e7a4a3ad4678dad880", {
	// 	variants: [
	// 		[
	// 			{
	// 				type: "defQ",
	// 				anses: ["213<sub>8</sub>", "128<sub>10</sub> + 8<sub>10</sub> + 4<sub>10</sub>", "10001010<sub>2</sub>"],
	// 				question: "Какое из перечисленных ниже выражений имеет наибольшее значение?",
	// 				score: 1,
	// 				trueanses: [2]
	// 			},
	// 			{
	// 				type: "defQ",
	// 				anses: ["214<sub>8</sub>", "128<sub>9</sub> + 8<sub>10</sub> + 4<sub>10</sub>", "10001011<sub>2</sub>"],
	// 				question: "Какое из перечисленных ниже выражений имеет наибольшее значение?",
	// 				score: 1,
	// 				trueanses: [0]
	// 			},
	// 		]
	// 	]
	// })

	socket.on("changeUsrData", (data) => {
		store.changeUsrData(data);
	})

	socket.on("UPDATE_ANSWER_USER", (data) => {
		store.updateAnswerUser(data.id, data.payload)
	})
	socket.on("UPDATE_ANSWER_REMOVE_USER", (data) => {
		store.updateAnswerRemoveUser(data.id, data.payload)
	})

}