// Подключаем контент из Chat
export default (Chat) => class extends Chat {
	constructor(){
		super("Hello")
		console.log("test init")
	}
	changeUsrData(data){
		console.log(data.type)
		switch(data.type){
			case "lname":
				this.updateClient(data.id, {"lname": data.payload.value});break;
			case "fname": 
				this.updateClient(data.id, {"fname": data.payload.value});break;
			case "variant": 
				this.updateClient(data.id, {"variant": data.payload.value});break;

			default: {
				console.log(":/, Не сработал свитч")
			}
		}
	}
};