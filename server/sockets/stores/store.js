// import { EventEmitter } from "events";
// import Dispatcher from "./dispatcher";
import User from "./classes/user.class";
import Chat from "./classes/chat.class";
import Test from "./classes/test.class";

import dispatcher from "./dispatcher";



export default class MainStore extends Test(Chat(User)) {  
	constructor(tests){
		// // Test(Chat(User))
		// //  ^
		// // Смотрим на последний родительский класс и вызываем super данного класса с аргументом конструктора этого родительского класса
		// // console.log(db.listTests())
		// let trueAnses = []

		// // Перебор всех тестов
		// if(tests != void(0) && tests.length != 0){
		// 	tests.map((i, j) => {
		// 		// Перебор вариантов
		// 		let TAvariants = []
		// 		i.variants.map((k, l) => {
		// 			// Перебор заданий
		// 			let TAproblems = []
		// 			k.map((q, w) => {
		// 				TAproblems.push({
		// 					no: w,
		// 					value: q.trueanses,
		// 					type: q.type,
		// 					score: q.score
		// 				})
		// 			})
		// 			TAvariants.push(TAproblems)
		// 		})
		// 		trueAnses.push({id: i._id, data: TAvariants})
		// 	})
		// 	super(trueAnses);
		// }

		super([]);
		

		
	}
}