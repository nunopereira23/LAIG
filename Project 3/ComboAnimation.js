class ComboAnimation extends Animation {
    constructor(scene, animationIds) {
        super(scene);
        this.animationIds = animationIds;
        this.totalTime = 0;
        for (let i = 0; i < this.animationIds.length; i++){
            let animation = this.scene.graph.animations[this.animationIds[i]];
            this.totalTime += animation.totalTime;
        }
    }

	/**
	 * Returns a transformation matrix in function of the given time.
	 * @param t Time between 0 and 1.
	 */
    getTransform(t) {
        if (t > 1) {
            t = 1;
        }
        let elapsedTime = 0;
        for (let i = 0; i < this.animationIds.length; i++) {
            let animation = this.scene.graph.animations[this.animationIds[i]];
            let fractionOfTotal = animation.totalTime / this.totalTime;
            if (elapsedTime + fractionOfTotal >= t) {
                let animT = (t - elapsedTime) / fractionOfTotal;
                return animation.getTransform(animT);
            }
            elapsedTime += fractionOfTotal;
        }

        return null;
    }
}