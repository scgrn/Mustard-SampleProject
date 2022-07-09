layout (location = 0) in vec3 position;
layout (location = 1) in vec2 texCoord;
layout (location = 2) in vec4 color;

out vec4 Color;
out vec2 TexCoord;

uniform mat4 projection;

void main() {
    gl_Position = projection * vec4(position, 1.0f);
    Color = color;
    TexCoord = texCoord;
}
