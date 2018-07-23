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
		socket.emit("getDataTest", data);
	})
}