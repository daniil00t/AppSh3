export default function(socket, store){
	let self = this;
	let id = socket.id;
	let ip = socket.handshake.address;
	console.log(`connected user, id: ${id}, ip: ${ip}`);

	// add Client
	store.addClient({
		id: id,
		ip: ip,
		app: "chat"
	});
	
	// init data to client
	socket.emit("init_client", {
		id: id,
		ip: ip,
		hello: store.getChatHello()
	});

	// Изменение имени клиента
	socket.on("changeNameUsr@soc", (data) => {
		let engagedName = false;
		store.getClients().map((i, j) => {
			if(i.name == data.name){
				engagedName = true;
			}
		});
		if(!engagedName) store.updateClient(data.id, {name: data.name});
		else {
			socket.emit("errorUsr@soc", {nameError: "name is holded", noError: 1, descError: "Вы использовали уже занятое имя другим пользователем.", helpError: "Пожалуйста, придумайте другое имя пользователя."});
			console.log("name is hold");
		}
	});
	// Изменение авы клиента
	socket.on("changePathImgUsr@soc", (data)=>{
		store.updateClient(data.id, {path: data.path})
	});
	// сообщение...
	socket.on("addMassageToChat@soc", (data) => {
		console.log(data);
		socket.broadcast.emit("newMassageToChatUsers", {
			id: data.id, 
			nameUsr: data.nameUsr, 
			pathAva: data.pathAva, 
			massage: data.massage
		});
	});

}