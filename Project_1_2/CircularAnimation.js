var degToRad = Math.PI / 180;

/**
 * CircularAnimation
 * @constructor
 */
class CircularAnimation extends Animation {
	constructor(scene, speed, centerX, centerY, centerZ, radius, startAng, rotAng) {
		super(scene);
		this.speed = speed;
		this.center = [centerX, centerY, centerZ];
		this.radius = radius;
		this.startAng = startAng * degToRad;
		this.rotAng = rotAng * degToRad;

		this.totalDistance = this._getTotalDistance();
		this.totalTime = this.totalDistance / this.speed;
	}
	
	/**
	 * Returns a transformation matrix in function of the given time.
	 * @param t Time between 0 and 1.
	 */
	getTransform(t) {
		if(t > 1){
			t = 1;
		}

		let transformMatrix = mat4.create();
		mat4.identity(transformMatrix);
		mat4.translate(transformMatrix, transformMatrix, this.center);
		mat4.rotate(transformMatrix, transformMatrix, this.startAng + (this.rotAng * t), [0, 1, 0]);
		mat4.translate(transformMatrix, transformMatrix, [this.radius, 0, 0]);
		mat4.rotate(transformMatrix, transformMatrix, -Math.PI/2, [0, 1, 0]);

		return transformMatrix;
	}

	_getTotalDistance() {
		return Math.abs(this.rotAng * this.radius);
	}

	_getTotalTime(){
		return totalTime;
	}
}