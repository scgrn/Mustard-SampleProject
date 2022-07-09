in vec4 Color;
in vec2 TexCoord;

// this will eventually be in a uniform buffer object
uniform mat4 colorTransform;

out vec4 color;

uniform sampler2D Texture;

void main() {
    color = texture(Texture, TexCoord) * Color;
	color = color * colorTransform;
}
