varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D texture_sampler;

uniform lowp vec4 time;

float rand(vec3 n) {
	// some expression that simulates a random number given some input (I didn't write this bit)
	return fract(cos(dot(n, vec3(12.9898, 4.1414, 4.1414))) * 43758.5453);
}

float noise(vec3 n) {
	vec3 gtl = floor(n);
	vec3 pos = smoothstep(vec3(0), vec3(1), fract(n));

	// back plane grid square gradients
	vec3 tlb_grad = vec3(rand(gtl), rand(gtl), rand(gtl));
	vec3 trb_grad = vec3(rand(gtl + vec3(1,0,0)), rand(gtl + vec3(1,0,0)), rand(gtl + vec3(1,0,0)));
	vec3 blb_grad = vec3(rand(gtl + vec3(0,1,0)), rand(gtl + vec3(0,1,0)), rand(gtl + vec3(0,1,0)));
	vec3 brb_grad = vec3(rand(gtl + vec3(1,1,0)), rand(gtl + vec3(1,1,0)), rand(gtl + vec3(1,1,0)));
	// front plane grid square gradients
	vec3 tlf_grad = vec3(rand(gtl + vec3(0,0,1)), rand(gtl + vec3(0,0,1)), rand(gtl + vec3(0,0,1)));
	vec3 trf_grad = vec3(rand(gtl + vec3(1,0,1)), rand(gtl + vec3(1,0,1)), rand(gtl + vec3(1,0,1)));
	vec3 blf_grad = vec3(rand(gtl + vec3(0,1,1)), rand(gtl + vec3(0,1,1)), rand(gtl + vec3(0,1,1)));
	vec3 brf_grad = vec3(rand(gtl + vec3(1,1,1)), rand(gtl + vec3(1,1,1)), rand(gtl + vec3(1,1,1)));

	//back plane grid square dot products
	float tlb_dot = dot(tlb_grad, pos);
	float trb_dot = dot(trb_grad, pos);
	float blb_dot = dot(blb_grad, pos);
	float brb_dot = dot(brb_grad, pos);
	//front plane grid square dot products
	float tlf_dot = dot(tlf_grad, pos);
	float trf_dot = dot(trf_grad, pos);
	float blf_dot = dot(blf_grad, pos);
	float brf_dot = dot(brf_grad, pos);

	// interpolated dot products back
	float top_edge_back = mix(tlb_dot, trb_dot, pos.x);
	float bottom_edge_back =  mix(blb_dot, brb_dot, pos.x);

	// interpolated dot products front
	float top_edge_front = mix(tlf_dot, trf_dot, pos.x);
	float bottom_edge_front = mix(blf_dot, brf_dot, pos.x);

	float front_to_back_top = mix(top_edge_back, top_edge_front, pos.z);
	float front_to_back_bottom = mix(bottom_edge_back, bottom_edge_front, pos.z);

	return mix(front_to_back_top, front_to_back_bottom, pos.y);
	
	
// 	vec2 gtl = floor(n);
// 	vec2 pos = smoothstep(vec2(0), vec2(1), fract(n));
// 
// 	vec2 tl_grad = vec2(rand(gtl), rand(gtl));
// 	vec2 tr_grad = vec2(rand(gtl + vec2(1, 0)), rand(gtl + vec2(1, 0)));
// 	vec2 bl_grad = vec2(rand(gtl + vec2(0, 1)), rand(gtl + vec2(0, 1)));
// 	vec2 br_grad = vec2(rand(gtl + vec2(1, 1)), rand(gtl + vec2(1, 1)));
// 	
// 	float tl_dot = dot(tl_grad, pos);
// 	float tr_dot = dot(tr_grad, vec2(pos.x -1.0, pos.y));
// 	float bl_dot = dot(bl_grad, vec2(pos.x, pos.y -1.0));
// 	float br_dot = dot(br_grad, vec2(pos.x - 1.0, pos.y - 1.0));
// 
// 	float top_edge = mix(tl_dot, tr_dot, pos.x);
// 	float bottom_edge = mix(bl_dot, br_dot, pos.x);
// 	return mix(top_edge, bottom_edge, pos.y);
}

void main()
{
	float amplitude = 20.0;
	// for(int i =0; i< 1; i++) {
	// 	intensity += noise(vec3(var_texcoord0.xy, time.x) * amplitude);
	// 	amplitude *= 1.5;
	// }
	
	// intensity *= 5;
	float intensity = noise(vec3(var_texcoord0.xy, frac(time.x)) * amplitude);
	
	gl_FragColor = vec4(intensity, intensity, intensity, 1.0);
}
