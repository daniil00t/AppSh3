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
	console.log(`connected user, id: ${id}, ip: ${ip}`);
	socket.emit("connected", {
		id: id,
		ip: ip
	})
	db.listTests().then((data) => {
		socket.emit("getDataTest", filterTAnses(data));
	})
}