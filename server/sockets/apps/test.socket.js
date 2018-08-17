const filterTAnses = (arr) => {
	let _arr = arr;
	_arr.variants.map((i, j) => {
		i.map((k, l) => {
			_arr.variants[j][l].trueanses = null
		})
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
		// k - номер активного теста
		let k = 0;
		socket.emit("getDataTest", filterTAnses(data[k]));
	})

	// db.removeTest("5ac8ea66e45b041348128ac5");
	// db.removeTest("5ac8eaec68352c16604b478a");
	// db.removeTest("5ac8eafddf7ae7138468b9b5");

	// db.updateTest("5b69a8e7a4a3ad4678dad880", {
	// 	variants: [
	// 		// variant #1
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
	// 			}
	// 		],
	// 		// variant #2
	// 		[
	// 			{
	// 				type: "defQ",
	// 				anses: ["2132<sub>8</sub>", "12833<sub>10</sub> + 832<sub>1</sub> + 423<sub>10</sub>", "100111111<sub>3</sub>"],
	// 				question: "Какое из перечисленных ниже выражений имеет наибольшее значение? А?",
	// 				score: 1,
	// 				trueanses: [2]
	// 			},
	// 			{
	// 				type: "defQ",
	// 				anses: ["214<sub>8</sub>", "128<sub>9</sub> + 8<sub>10</sub> + 4<sub>10</sub>", "10001011<sub>2</sub>"],
	// 				question: "Какое из перечисленных ниже выражений имеет наибольшее значение?",
	// 				score: 1,
	// 				trueanses: [0]
	// 			}
	// 		],
	// 		// variant #3
	// 		[
	// 			{
	// 				type: "defQ",
	// 				anses: ["213<sub>8</sub>", "128<sub>10</sub> + 8<sub>10</sub> + 4<sub>10</sub>", "10001010<sub>2</sub>"],
	// 				question: "Даны 4 числа, они записаны с использованием различных систем счисления. Укажите среди этих чисел то, в двоичной записи которого содержится ровно 6 единиц. Если таких чисел несколько, укажите наибольшее из них.",
	// 				score: 1,
	// 				trueanses: [2]
	// 			},
	// 			{
	// 				type: "defQ",
	// 				anses: ["214<sub>8</sub>", "128<sub>9</sub> + 8<sub>10</sub> + 4<sub>10</sub>", "10001011<sub>2</sub>"],
	// 				question: "Какое из перечисленных ниже выражений имеет наибольшее значение?",
	// 				score: 1,
	// 				trueanses: [0]
	// 			}
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