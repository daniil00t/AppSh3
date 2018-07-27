import crypto from "crypto";

export function encryptHash(data, key){
	let cipher = crypto.createCipher('aes-256-cbc', key);
	let crypted = cipher.update(data, 'utf-8', 'hex');
	crypted += cipher.final('hex');
	return crypted;
}

export function decryptHash (data, key) {
	let decipher = crypto.createDecipher('aes-256-cbc', key);
	let decrypted = decipher.update(data, 'hex', 'utf-8');
	decrypted += decipher.final('utf-8');
	return decrypted;
}

// encryptLogPass - функция, умеющая кодировать логин и пароль в хэш(ключ используется - Осман)

export function encryptLogPass(login, pass){
	let l1 = login.length < 10 ? `0${login.length}` : login.length;
	let p1 = pass.length < 10 ? `0${pass.length}` : pass.length;
	let key = "Osman" + l1 + p1;
	return encryptHash(login + pass, key) + l1 + p1;
}

// decryptLogPass - функция, умеющая декодировать хэш в обычный объкт, сост. из логина и пароля
export function decryptLogPass(hash){
	let _hash = hash.substr(0, hash.length-4);
	let _nums =  hash.substr(hash.length-4, hash.length);

	let n1 = Number(_nums.substr(0, 2));
	let n2 = Number(_nums.substr(2, 4));
	let key = "Osman" + _nums;
	return {str: decryptHash(_hash, key), login: decryptHash(_hash, key).substr(0, n1), pass: decryptHash(_hash, key).substr(n1, n1+n2)}
}
