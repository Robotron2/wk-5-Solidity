const mod = (n, m) => ((n % m) + m) % m

const gcd = (a, b) => {
	// a = Math.abs(a)
	// b = Math.abs(b)

	if (a === 0 && b === 0) return undefined

	if (b === 0) return a
	while (b !== 0) {
		const r = a % b
		a = b
		b = r
	}
	return a
}

const modInverse = (a, m) => {
	let m0 = m
	let y = 0
	let x = 1

	if (m === 1) return 0

	while (a > 1) {
		if (m === 0) return null

		let q = Math.floor(a / m)
		let t = m

		m = a % m
		a = t
		t = y

		y = x - q * y
		x = t
	}

	if (x < 0) x += m0

	return x
}

const modPow = (base, exp, m) => {
	let result = 1
	base = mod(base, m)
	while (exp > 0) {
		if (exp % 2 === 1) result = mod(result * base, m)
		base = mod(base * base, m)
		exp = Math.floor(exp / 2)
	}
	return result
}

module.exports = {
	mod,
	gcd,
	modInverse,
	modPow,
}
