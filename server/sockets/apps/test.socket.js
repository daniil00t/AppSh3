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
		socket.emit("getDataTest", filterTAnses(data));
	})
	// db.updateTest("5ac8ea66e45b041348128ac5", { data: [
	// 	{ anses:["213\u003csub\u003e8\u003c/sub\u003e","128\u003csub\u003e10\u003c/sub\u003e + 8\u003csub\u003e10\u003c/sub\u003e + 4\u003csub\u003e10\u003c/sub\u003e","10001100\u003csub\u003e2\u003c/sub\u003e"],trueanses:[2],_id:"5ab13b053ad35c0284233fb2",type:"defQ",num:0,question:"Какое из перечисленных ниже выражений имеет наибольшее значение?",__v:0,score:1},
	// 	{ anses:["223\u003csub\u003e8\u003c/sub\u003e","138\u003csub\u003e10\u003c/sub\u003e + 5\u003csub\u003e10\u003c/sub\u003e + 4\u003csub\u003e10\u003c/sub\u003e","10111010\u003csub\u003e2\u003c/sub\u003e"],trueanses:[0],_id:"5ab13b053ad35c0284233fb1",type:"defQ",num:1,question:"Какое из перечисленных ниже выражений имеет наибольшее значение?",__v:1,score:1},
	// 	{ anses:["243\u003csub\u003e8\u003c/sub\u003e","125\u003csub\u003e10\u003c/sub\u003e + 8\u003csub\u003e10\u003c/sub\u003e + 4\u003csub\u003e10\u003c/sub\u003e","10001000\u003csub\u003e2\u003c/sub\u003e"],trueanses:[1],_id:"5ab13b053ad35c0284233fb2",type:"defQ",num:2,question:"Какое из перечисленных ниже выражений имеет наибольшее значение?",__v:2,score:1}

	// ]})

	socket.on("changeUsrData", (data) => {
		store.changeUsrData(data);
	})

	socket.on("UPDATE_ANSWER_USER", (data) => {
		store.updateAnswerUser(data.id, data.payload)
	})

}