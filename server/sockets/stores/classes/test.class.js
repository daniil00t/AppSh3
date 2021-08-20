import dispatcher from "../dispatcher";
// Подключаем контент из Chat
import { appData } from '../../../../etc/config.json';
export default (Chat) => class extends Chat {
	constructor(){
		console.log("go!")
		super("Hello")
		this.users_to_data = []
		this.data_users = []
		this.data_true_anses = []
		this.activeTest = appData.test.active_test_default
	}
	changeUsrData(data){
		console.log(data.type)
		switch(data.type){
			case "lname":
				this.updateClient(data.id, {lname: data.payload.value});break;
			case "fname": 
				this.updateClient(data.id, {fname: data.payload.value});break;
			case "variant": 
				this.updateClient(data.id, {variant: data.payload.value});break;
			case "start": 
				this.updateClient(data.id, {testing: data.payload.state});break;

			default: {
				console.log(":/, Не сработал свитч")
			}
		}
	}
	getDataUsers(){
		return this.data_users
	}
	updateAnswerUser(id, data){
		let self = this;
		if(this.data_users.length > 0) {
			let updated = false;
			this.data_users.map((i, j) => {
				if(i.id == id){
					let no = false;
					i.data.map((k, l) => {
						if(k.no == data.no){
							self.data_users[j].data[l].value = data.value;
							no = true;
						}
					})

					if(!no){
						self.data_users[j].data.push(data)
					}
					updated = true;
				}
			})
			if(!updated){
				this.data_users.push({
					id: id,
					data: [data]
				})
			}
		}
		else{
			this.data_users.push({
				id: id,
				data: [data]
			})
		}
		// this.data_users.map((i) => {
		// 	console.log(i.data)
		// })
		dispatcher.dispatch({
			type: "UPDATE_ANSWER_USER",
			payload: this.data_users
		})
	}
	updateAnswerRemoveUser(id, data){
		let self = this;
		this.data_users.map((i, j) => {
			if(i.id == id){
				i.data.map((k, l) => {
					if(k.no == data.no){
						self.data_users[j].data.splice(l, 1)
					}
				})
			}
		});
		dispatcher.dispatch({
			type: "UPDATE_ANSWER_USER",
			payload: this.data_users
		})
		return this.data_users;
	}
	setTrueAnses(anses){
		this.data_true_anses = anses;
	}
	getTrueAnses(){
		return this.data_true_anses.length > 0 ? this.data_true_anses.length : []
	}
	updateScoreUser(){
		/*
		score = 0
		arr = @state.users
		lengthProblemsTests = 0
		@state.users.map (i, j) => 
			data.map (k, l) =>
				if i.id == k.id
					variant = i.variant - 1
					# начинаем проверку
					k.data.map (q, w)=>
						@state.data_true_anses[0].data[variant].map (r, t)=>
							console.log q, r
							if q.no == r.no
								if q.value == r.value[0]
									score += r.score

					lengthProblemsTests = @state.data_true_anses[0].data[variant].length
					arr[j].score = score
					arr[j].points = Math.round(score / lengthProblemsTests * 100)
					score = 0
		@setState users: arr
		*/
		var score = 0
		var users = this.getClients()
		var lengthProblemsTests = 0
		var data = this.data_users
		var true_anses = this.getTrueAnses()

		users.map((i, j) => {
			if(i.app == "test"){
				data.map((k, l) => {
					if(i.id == k.id){
						var variant = i.variant - 1
						k.data.map((q, w) => {
							 this.data_true_anses[0].data[variant].map((r, t) => {
								if(q.no == r.no){
									if(q.value == r.value[0]){
										score += r.score
									}
								}
							})
						})
						lengthProblemsTests = this.data_true_anses[0].data[variant].length
						users[j].score = score
						users[j].points = Math.round(score / lengthProblemsTests * 100)
						score = 0
					}
				})
			}
		})
		this.clients = users
	}
	addUserToData(id){
		let data = this.getClients();
		data.map((i, j) => {
			if(i.id == id){
				this.users_to_data.push(data[j]);
			}
		})
		console.log("add to test: ", this.users_to_data);
	}
	getUsersToData(){
		return this.users_to_data;
	}

	setActiveTest(value){
		this.activeTest = value;
		return value;
	}
	getActiveTest(){
		return this.activeTest;
	}
};