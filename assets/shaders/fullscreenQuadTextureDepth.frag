uniform sampler2D textureUnit;

uniform sampler2D depthTexture;

in vec2 textureCoords;
out vec4 color;

void main() {
    gl_FragDepth = texture(depthTexture, textureCoords).r;
	color = texture(textureUnit, textureCoords);
}
