#ifdef GL_ES
precision highp float;
#endif

varying vec4 vFinalColor;
varying vec2 vTextureCoord;

uniform sampler2D uSampler;
uniform bool uUseTexture;

uniform float timeFactor;
uniform vec4 saturatedColor;


void main() {
    // Branching should be reduced to a minimal. 
	// When based on a non-changing uniform, it is usually optimized.
    vec4 color = mix(vFinalColor, saturatedColor, timeFactor);
	if (uUseTexture)
	{
		vec4 textureColor = texture2D(uSampler, vTextureCoord);
		gl_FragColor = textureColor * color;
	}
	else
		gl_FragColor = color;
}