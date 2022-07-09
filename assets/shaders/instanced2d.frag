in vec4 Color;
in vec2 TexCoord;
flat in int TextureUnit;

uniform sampler2D textureSamplers[16];

// this will eventually be in a uniform buffer object
uniform mat4 colorTransform;

out vec4 color;

/*
layout (std140) uniform UniformBlock {
	mat4 projectionMatrix;
	mat4 viewMatrix;
	mat4 colorTransform;
	int timer;
	float randomSeed;
};
*/

void main() {
	color = texture(textureSamplers[TextureUnit], TexCoord) * Color;
	color = color * colorTransform;
}
