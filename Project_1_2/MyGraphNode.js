/**
 * MyGraphNode class, representing an intermediate node in the scene graph.
 * @constructor
**/

function MyGraphNode(graph, nodeID, selectable = false) {
    this.graph = graph;

    this.nodeID = nodeID;
    this.selectable = selectable;

    // IDs of child nodes.
    this.children = [];

    // IDs of child nodes.
    this.leaves = [];

    // The material ID.
    this.materialID = null ;

    // The texture ID.
    this.textureID = null ;

    this.transformMatrix = mat4.create();
    mat4.identity(this.transformMatrix);

    this.animationIds = [];
}

/**
 * Adds the reference (ID) of another node to this node's children array.
 */
MyGraphNode.prototype.addChild = function(nodeID) {
    this.children.push(nodeID);
}

/**
 * Adds a leaf to this node's leaves array.
 */
MyGraphNode.prototype.addLeaf = function(leaf) {
    this.leaves.push(leaf);
}

MyGraphNode.prototype.addAnimation = function(animId) {
    this.animationIds.push(animId);
}

/**
 * Gets the transformation matrix for the animation being run at a certain time.
 * currentSeconds - Seconds since the start of the first animation.
 */
MyGraphNode.prototype.getAnimTransform = function(currentSeconds) {
    let elapsedTime = 0;
    for (let i = 0; i < this.animationIds.length; i++) {
        let animation = this.graph.animations[this.animationIds[i]];
        if (elapsedTime + animation.totalTime > currentSeconds || i + 1 == this.animationIds.length) {
            let animT = (currentSeconds - elapsedTime) / animation.totalTime;
            return animation.getTransform(animT);
        }
        elapsedTime += animation.totalTime;
    }
    return null;
}
