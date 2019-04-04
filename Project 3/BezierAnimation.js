class BezierAnimation extends Animation {
	/**
	 * 
	 * @param {XMLscene} scene 
	 * @param {number} speed 
	 * @param {*} controlPoints 
	 * @param {boolean} rotateAlongAxis If true, rotate object so it follows its direction.
	 */
	constructor(scene, speed, controlPoints, rotateAlongAxis = true) {
		super(scene);
		this.speed = speed;
		this.P1 = controlPoints[0];
		this.P2 = controlPoints[1];
		this.P3 = controlPoints[2];
		this.P4 = controlPoints[3];

		this.prevCoordinates = this._getCurrentCoordinates(-0.001);
		this.prevAngle = 0;

		this.totalDistance = this._getTotalDistance();
		this.totalTime = this.totalDistance / this.speed;

		this.rotateAlongAxis = rotateAlongAxis;
	}

	/**
	 * Returns a transformation matrix in function of the given time.
	 * @param {number} t Time between 0 and 1.
	 */
	getTransform(t) {
		if (t > 1) {
			t = 1;
		}
		let currentCoordinates = this._getCurrentCoordinates(t);
		let deltaCoords = subtractArrays(currentCoordinates, this.prevCoordinates);
		let angle = this._getXZOrientation(deltaCoords);
		if (deltaCoords[0] == 0 && deltaCoords[2] == 0) {
			angle = this.prevAngle;
		}

		let transformMatrix = mat4.create();
		mat4.identity(transformMatrix);
		mat4.translate(transformMatrix, transformMatrix, currentCoordinates);
		if (this.rotateAlongAxis) {
			mat4.rotate(transformMatrix, transformMatrix, angle, [0, 1, 0]);
		}
		
		if (t < 1) {
			this.prevCoordinates = currentCoordinates;
			this.prevAngle = angle;
		}
		return transformMatrix;
	}

	_getXZOrientation(deltaCoords) {
		let z = deltaCoords[2];
		let x = deltaCoords[0];
		if (x == 0) {
			return -Math.PI / 2;
		} else {
			return -Math.atan(z/x);
		}
	}

	_getCurrentCoordinates(t) {
		let x = this._calcBezierCoordinate(t, 0);
		let y = this._calcBezierCoordinate(t, 1);
		let z = this._calcBezierCoordinate(t, 2);

		return [x, y, z];
	}

	_calcBezierCoordinate(t, coordInd) {
		return Math.pow((1 - t), 3) * this.P1[coordInd]
				+ (3 * t * Math.pow((1 - t), 2)) * this.P2[coordInd]
				+ (3 * t*t * (1 - t)) * this.P3[coordInd]
				+ (t*t*t) * this.P4[coordInd];
	}

	/**
	 * Estimated distance: Average between chord and control net.
	 * Chord = Distance between start and destination.
	 * Control net = Sum of distances between each consecutive points.
	 */
	_getTotalDistance() {
		let chord = this._getDistance(this.P4, this.P1);
		let controlNet = this._getDistance(this.P1, this.P2)
						+ this._getDistance(this.P2, this.P3)
						+ this._getDistance(this.P3, this.P4);
		return (chord + controlNet) / 2;
	}

	_getDistance(point1, point0) {
		let distance = Math.pow(point1[0] - point0[0], 2);
			distance += Math.pow(point1[1] - point0[1], 2);
			distance += Math.pow(point1[2] - point0[2], 2);
			distance = Math.sqrt(distance);
		return distance;
	}

	_getTotalTime(){
		return totalTime;
	}
}