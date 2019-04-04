/**
 * Returns a 3D array from the cross product of two 3D arrays.
 * @param {array} a
 * @param {array} b
 */
crossProduct = function(a, b) {
	let x = a[1] * b[2] - a[2] * b[1];
	let y = -(a[0] * b[2] - a[2] * b[0]);
	let z = a[0] * b[1] - a[1] * b[0];
	return [x, y, z];
}

/**
 * Returns an array in which each element is the difference
 * between a and b's respective elements.
 * a and b must have equal length.
 */
subtractArrays = function(a, b) {
	let res = [];
	for (let i = 0; i < a.length; i++) {
		res.push(a[i] - b[i]);
	}
	return res;
}