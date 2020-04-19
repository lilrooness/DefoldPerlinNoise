varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D texture_sampler;

float rand(vec2 n) {
	// some expression that simulates a random number given some input (I didn't write this bit)
	return fract(cos(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 n) {
	vec2 gtl = floor(n);
	vec2 pos = smoothstep(vec2(0), vec2(1),fract(n));

	vec2 tl_grad = vec2(rand(gtl), rand(gtl));
	vec2 tr_grad = vec2(rand(gtl + vec2(1, 0)), rand(gtl + vec2(1, 0)));
	vec2 bl_grad = vec2(rand(gtl + vec2(0, 1)), rand(gtl + vec2(0, 1)));
	vec2 br_grad = vec2(rand(gtl + vec2(1, 1)), rand(gtl + vec2(1, 1)));
	
	float tl_dot = dot(tl_grad, pos);
	float tr_dot = dot(tr_grad, vec2(pos.x -1.0, pos.y));
	float bl_dot = dot(bl_grad, vec2(pos.x, pos.y -1.0));
	float br_dot = dot(br_grad, vec2(pos.x - 1.0, pos.y - 1.0));

	float top_edge = mix(tl_dot, tr_dot, pos.x);
	float bottom_edge = mix(bl_dot, br_dot, pos.x);
	return mix(top_edge, bottom_edge, pos.y);
}

void main()
{
	float intensity = 0.0;
	float amplitude = 4.0;
	for(int i =0; i< 4; i++) {
		intensity += noise(var_texcoord0 * amplitude);
		amplitude *= 1.5;
	}
	
	intensity *= 5;
	
	gl_FragColor = vec4(intensity, intensity, intensity, 1.0);//texture2D(texture_sampler, var_texcoord0.xy) * 1;
}
