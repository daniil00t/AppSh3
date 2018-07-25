import dispatcher from "../dispatcher";

export default (User) => class extends User {
	constructor(chat_hello){
		super();
		this.chat_hello = chat_hello;
	}

	updateChatHello(value){
		this.chat_hello = value;
		dispatcher.dispatch({
			type: "CHANGE_CHAT_HELLO",
			payload: value
		});
	}
	getChatHello(){
		return this.chat_hello;
	}
};