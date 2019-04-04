/**
 * MyTriangle
 * @constructor
 */
 function MyTriangle(scene, x1,y1,z1,x2,y2,z2,x3,y3,z3) {
 	CGFobject.call(this,scene);

    this.x1=x1;
    this.y1=y1;
    this.z1=z1;
    this.x2=x2;
    this.y2=y2;
    this.z2=z2;
    this.x3=x3;
    this.y3=y3;
    this.z3=z3;

 	this.initBuffers();
 };

 MyTriangle.prototype = Object.create(CGFobject.prototype);
 MyTriangle.prototype.constructor = MyTriangle;

 MyTriangle.prototype.initBuffers = function() {
 	this.vertices = [
      this.x1, this.y1, this.z1,
      this.x2, this.y2, this.z2,
      this.x3, this.y3, this.z3,
 	];

 	this.indices = [
 	  0, 1, 2
 	];

    let side12 = [this.x2-this.x1, this.y2-this.y1, this.z2-this.z1];
    let side13 = [this.x3-this.x1, this.y3-this.y1, this.z3-this.z1];
    let normal = crossProduct(side12, side13);

 	this.normals = [
 	  normal[0], normal[1], normal[2],
 	  normal[0], normal[1], normal[2],
 	  normal[0], normal[1], normal[2]
 	];

    let b = Math.sqrt(Math.pow(this.x3-this.x1 ,2)
                   + Math.pow(this.y3-this.y1 ,2)
                   + Math.pow(this.z3-this.z1 ,2));
                   
    let a = Math.sqrt(Math.pow(this.x2-this.x3 ,2)
                   + Math.pow(this.y2-this.y3 ,2)
                   + Math.pow(this.z2-this.z3 ,2));

    let c = Math.sqrt(Math.pow(this.x2 - this.x1, 2)
 	                   + Math.pow(this.y2 - this.y1, 2)
 	                   + Math.pow(this.z2 - this.z1, 2));
  	                  
    let cosBeta = (a*a - b*b + c*c) / (2*a*c);
    let sinBeta = Math.sqrt(1 - cosBeta*cosBeta);

    let ptX = c - a * cosBeta;
    let ptY = a * sinBeta;

    this.texCoords=[
      0, 0,
      c, 0,
      ptX, 1 - ptY
    ];

 	this.primitiveType = this.scene.gl.TRIANGLES;
 	this.initGLBuffers();
 };