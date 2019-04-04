/**
 * MyPatch
 * @constructor
 */
function MyPatch(scene, uDivs, vDivs, controlVertexes) {
	CGFobject.call(this, scene);
    
	let uOrder = controlVertexes.length - 1;
	let vOrder = controlVertexes[0].length - 1;

    let knots1 = this.getKnotsVector(uOrder);
	let knots2 = this.getKnotsVector(vOrder);

	let nurbsSurface = new CGFnurbsSurface(uOrder, vOrder, knots1, knots2, controlVertexes);
	getSurfacePoint = function(u, v) {
		return nurbsSurface.getPoint(u, v);
	};
	
	this.surface = new CGFnurbsObject(scene, getSurfacePoint, uDivs, vDivs);
};

MyPatch.prototype = Object.create(CGFobject.prototype);
MyPatch.prototype.constructor = MyPatch;

/**
 * Initializes a knots vector of a given degree.
 * [(degree+1) 0's, (degree+1) 1's]
 * @param {int} degree
 */
MyPatch.prototype.getKnotsVector = function(degree) {
	var v = new Array();
	for (var i=0; i<=degree; i++) {
		v.push(0);
	}
	for (var i=0; i<=degree; i++) {
		v.push(1);
	}
	return v;
}

MyPatch.prototype.display = function() {
    this.surface.display();
}