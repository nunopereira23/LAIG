/**
 * MySphere
 * @constructor
 */

function MySphere(scene, radius, slices, stacks) {
	CGFobject.call(this,scene);

	this.radius = radius;
	this.slices = slices;
	this.stacks = stacks;

	this.initBuffers();
};

MySphere.prototype = Object.create(CGFobject.prototype);
MySphere.prototype.constructor = MySphere;

MySphere.prototype.initBuffers = function() {

	this.vertices = [];
	this.indices = [];
	this.normals = [];
	this.texCoords = [];

	var sliceStep = (2 * Math.PI)/ this.slices;
	var stackStep = Math.PI/ this.stacks;

	var actStack  = 0;
	var actSlice = 0;

	for(let i = 0 ; i <= this.stacks ; i++){
		actStack = i * stackStep;
		for(var j = 0 ; j <= this.slices; j++){
			actSlice = j * sliceStep;
			var x = this.radius * Math.cos(actSlice) * Math.sin(actStack);
			var y = this.radius * Math.cos(actStack);
			var z = this.radius * Math.sin(actStack) * Math.sin(actSlice);

			this.vertices.push(x,y,z);
			this.normals.push(x,y,z);
			this.texCoords.push(1 - i/this.stacks, 1- j/this.slices);

		}
	}


	for(var i = 0 ; i < this.stacks ; i++){
 		for(var j = 0; j < this.slices ; j++){
      		var x = i * (this.slices + 1) + j;
     		var y = (i + 1) * (this.slices + 1) + j;
 			this.indices.push(x,  (i + 1) * (this.slices + 1) + j + 1, y);
			this.indices.push(x,   i * (this.slices + 1) + j + 1, y + 1);
		}
	}

 	this.primitiveType = this.scene.gl.TRIANGLES;
 	this.initGLBuffers();
};