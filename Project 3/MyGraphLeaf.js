/**
 * MyGraphLeaf class, representing a leaf in the scene graph.
 * @constructor
**/
function MyGraphLeaf(graph, xmlelem) {
    this.type = graph.reader.getItem(xmlelem, 'type', ['rectangle', 'cylinder', 'sphere', 'triangle', 'patch']);
    let args = graph.reader.getString(xmlelem, 'args');
    let regex = /[+-]?\d+(\.\d+)?/g;
    let argList = args.match(regex).map(function(v) { return parseFloat(v); }); //regex magic
    switch (this.type) {
        case "rectangle":
            this.primitive = new MyQuad(graph.scene, argList[0], argList[1], argList[2], argList[3]);
            break;
        case "cylinder":
            this.primitive = new MyCylinder(graph.scene, argList[0], argList[1], argList[2], argList[3], argList[4], argList[5], argList[6]);
            break;
        case "sphere":
            this.primitive = new MySphere(graph.scene, argList[0], argList[1], argList[2]);
            break;
        case "triangle":
            this.primitive = new MyTriangle(graph.scene,  argList[0], argList[1], argList[2], argList[3], argList[4],  argList[5], argList[6], argList[7], argList[8]);
            break;
        case "patch":
            let controlVertexes = [];
            for (let line = 0; line < xmlelem.children.length; line++) {
                let cpline = [];
                for (let point = 0; point < xmlelem.children[line].children.length; point++) {
                    let xmlPoint = xmlelem.children[line].children[point];
                    let x = graph.reader.getString(xmlPoint, 'xx');
                    let y = graph.reader.getString(xmlPoint, 'yy');
                    let z = graph.reader.getString(xmlPoint, 'zz');
                    let w = graph.reader.getString(xmlPoint, 'ww');
                    let cppoint = [x, y, z, w];
                    cpline.push(cppoint);
                }
                controlVertexes.push(cpline);
            }
            this.primitive = new MyPatch(graph.scene, argList[0], argList[1], controlVertexes);
            break;
    }
}

/**
 * Displays the associated primitive.
 */
MyGraphLeaf.prototype.display = function() {
    this.primitive.display();
}

/**
 * Updates the internal texture coordinates buffers by dividing by the given amplification factors.
 * this.texCoords is not modified.
 */
MyGraphLeaf.prototype.updateTexCoords = function(ampS, ampT) {
    if (this.type == "patch") {
        return;
    }
    this.originalTexCoords = this.primitive.texCoords.slice();
    for (let i = 0; i < this.primitive.texCoords.length; i += 2) {
        this.primitive.texCoords[i] /= ampS;
    }
    for (let i = 1; i < this.primitive.texCoords.length; i += 2) {
        this.primitive.texCoords[i] /= ampT;
    }
    this.primitive.updateTexCoordsGLBuffers();
    this.primitive.texCoords = this.originalTexCoords;
}