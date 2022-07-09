in vec2 UV;
in vec3 positionWorldSpace;
in vec3 normalCameraSpace;
in vec3 eyeDirectionCameraSpace;
in vec3 lightDirectionCameraSpace;

out vec4 color;

uniform sampler2D textureSampler;
uniform mat4 MV;
uniform vec3 lightPositionWorldSpace;

void main(){
	vec3 lightColor = vec3(1,1,1);
	float lightPower = 70.0f; // 50.0f;
	
	// material properties
	vec3 materialDiffuseColor = texture(textureSampler, UV).rgb;
	//vec3 materialAmbientColor = vec3(0.15,0.15,0.15) * materialDiffuseColor;
	vec3 materialAmbientColor = vec3(0.4,0.4,0.4) * materialDiffuseColor;
	vec3 materialSpecularColor = vec3(0.3,0.3,0.3);

	// distance to the light
	float distance = length(lightPositionWorldSpace - positionWorldSpace);
	// float distance = 10.0f; 
	
	// normal of the computed fragment, in camera space
	vec3 n = normalize(normalCameraSpace);
	// direction of the light (from the fragment to the light)
	vec3 l = normalize(lightDirectionCameraSpace );
	float cosTheta = clamp(dot(n, l), 0.0, 1.0);
	
	vec3 E = normalize(eyeDirectionCameraSpace);
	vec3 R = reflect(-l, n);
	float cosAlpha = clamp(dot(E, R), 0.0, 1.0);
	
	vec3 finalColor = 
		materialAmbientColor +
		materialDiffuseColor * lightColor * lightPower * cosTheta / (distance*distance) +
		materialSpecularColor * lightColor * lightPower * pow(cosAlpha, 5.0) / (distance*distance);

	color = vec4(vec3(finalColor), 1.0);
}