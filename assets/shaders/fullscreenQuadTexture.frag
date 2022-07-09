uniform sampler2D textureUnit;

in vec2 textureCoords;
out vec4 color;

void main() {
	color = texture(textureUnit, textureCoords);
}
