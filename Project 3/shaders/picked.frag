#ifdef GL_ES
precision highp float;
#endif

varying vec4 vFinalColor;
varying vec2 vTextureCoord;

uniform sampler2D uSampler;
uniform bool uUseTexture;

uniform vec4 pickedColor;


void main() {
	gl_FragColor = pickedColor;
}