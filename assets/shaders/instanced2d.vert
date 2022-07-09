layout (location = 0) in vec3 vertexPosition;

layout (location = 1) in vec3 position;
layout (location = 2) in vec2 size;
layout (location = 3) in vec2 scale;
layout (location = 4) in float rotation;
layout (location = 5) in vec4 texCoord;
layout (location = 6) in int textureUnit;
layout (location = 7) in vec4 color;
		
out vec4 Color;
out vec2 TexCoord;
flat out int TextureUnit;

// this will eventually be in a uniform buffer object
uniform mat4 projection;

void main() {
	vec4 newPos = vec4((vertexPosition * vec3(size, 1.0) * vec3(scale, 1)), 1.0f);
	
	gl_Position.x = (newPos.x * cos(rotation)) + (newPos.y * sin(rotation));
	gl_Position.y = (newPos.y * cos(rotation)) - (newPos.x * sin(rotation));
	gl_Position.z = newPos.z;
	gl_Position.w = newPos.w;
	
	gl_Position += vec4(position, 0);
	gl_Position = projection * gl_Position;

	vec2 uvs[4] = vec2[4](
		vec2(texCoord.z, texCoord.w),
		vec2(texCoord.z, texCoord.y),
		vec2(texCoord.x, texCoord.y),
		vec2(texCoord.x, texCoord.w)
	);
	TexCoord = uvs[gl_VertexID];
	
	TextureUnit = textureUnit;
    Color = color;
}
