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

	vec3 tlb_offset = vec3(0,0,0);
	vec3 trb_offset = vec3(1,0,0);
	vec3 blb_offset = vec3(0,1,0);
	vec3 brb_offset = vec3(1,1,0);

	vec3 tlf_offset = vec3(0,0,1);
	vec3 trf_offset = vec3(1,0,1);
	vec3 blf_offset = vec3(0,1,1);
	vec3 brf_offset = vec3(1,1,1);

	//back plane grid square dot products
	float tlb_dot = dot(tlb_grad, pos - tlb_offset);
	float trb_dot = dot(trb_grad, pos - trb_offset);
	float blb_dot = dot(blb_grad, pos - blb_offset);
	float brb_dot = dot(brb_grad, pos - brb_offset);
	//front plane grid square dot products
	float tlf_dot = dot(tlf_grad, pos - tlf_offset);
	float trf_dot = dot(trf_grad, pos - trf_offset);
	float blf_dot = dot(blf_grad, pos - blf_offset);
	float brf_dot = dot(brf_grad, pos - brf_offset);

	// interpolated dot products back
	float top_edge_back = mix(tlb_dot, trb_dot, pos.x);
	float bottom_edge_back =  mix(blb_dot, brb_dot, pos.x);

	// interpolated dot products front
	float top_edge_front = mix(tlf_dot, trf_dot, pos.x);
	float bottom_edge_front = mix(blf_dot, brf_dot, pos.x);

	float front_to_back_top = mix(top_edge_back, top_edge_front, pos.z);
	float front_to_back_bottom = mix(bottom_edge_back, bottom_edge_front, pos.z);

	return mix(front_to_back_top, front_to_back_bottom, pos.y);
}

void main()
{
	float amplitude = 4;
	float intensity = 0.0;
	for(int i =0; i< 4; i++) {
		intensity += noise(vec3(var_texcoord0.xy, time.x) * amplitude);
		amplitude *= 1.5;
	}
	
	gl_FragColor = vec4(intensity, intensity, intensity, 1.0);
}
