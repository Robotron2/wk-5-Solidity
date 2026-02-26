const { mod, modInverse, modPow, gcd } = require("./mod")

const M = 65537

console.log(mod(-5, M))
console.log(modInverse(9, M))
console.log(modPow(2, 5, M))

function createKeys(p, q, e) {
	const N = p * q

	const phi = (p - 1n) * (q - 1n)

	if (gcd(e, phi) !== 1n) {
		throw new Error("e and phi are not coprime. Choose a different e.")
	}

	const d = modInverse(e, phi)

	return {
		publicKey: { N, e },
		privateKey: { N, d },
	}
}

function encrypt(m, publicKey) {
	const { N, e } = publicKey
	return modPow(m, e, N)
}

function decrypt(c, privateKey) {
	const { N, d } = privateKey
	return modPow(c, d, N)
}

const p = 61n
const q = 53n
const e = 17n

const keys = createKeys(p, q, e)
console.log("Public Key:", keys.publicKey)
console.log("Private Key:", keys.privateKey)

const message = 65n
const ciphertext = encrypt(message, keys.publicKey)
console.log("Encrypted Ciphertext:", ciphertext)

const decryptedMessage = decrypt(ciphertext, keys.privateKey)
console.log("Decrypted Message:", decryptedMessage)

console.log(`Success: ${message === decryptedMessage}`)
