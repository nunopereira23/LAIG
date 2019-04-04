/**
 * MyQuad
 * @param gl {WebGLRenderingContext}
 * @constructor
 */
function MyQuad(scene, leftX, topY, rightX, bottomY) {
	CGFobject.call(this,scene);
	
	this.leftX = leftX;
	this.topY = topY;
	this.rightX = rightX;
	this.bottomY = bottomY;

	this.minS = 0;
	this.minT = 0;
	this.maxS = Math.abs(rightX - leftX);
	this.maxT = Math.abs(topY - bottomY);
	
	this.initBuffers();
};

MyQuad.prototype = Object.create(CGFobject.prototype);
MyQuad.prototype.constructor=MyQuad;

MyQuad.prototype.initBuffers = function () {
	//3 4
	//1 2
	this.vertices = [
            this.leftX, this.bottomY, 0,
            this.rightX, this.bottomY, 0,
            this.leftX, this.topY, 0,
           	this.rightX, this.topY, 0
			];

	this.indices = [
            0, 1, 2, 
			3, 2, 1
// 			2, 1, 0,
// 			1, 2, 3,
        ];
	
	this.normals = [
			0, 0, 1,
			0, 0, 1,
 			0, 0, 1,
 			0, 0, 1
	]

	this.texCoords = [
		this.minS, this.maxT,
		this.maxS, this.maxT,
		this.minS, this.minT,
		this.maxS, this.minT	
	]

	this.primitiveType=this.scene.gl.TRIANGLES;
	this.initGLBuffers();
};