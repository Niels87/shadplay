#ifdef PREPASS_PIPELINE
#import bevy_pbr::prepass_io::{VertexOutput, FragmentOutput};
#import bevy_pbr::pbr_deferred_functions::deferred_output;
#else
#import bevy_pbr::pbr_functions::{apply_pbr_lighting, main_pass_post_lighting_processing};
#endif

#import bevy_pbr::forward_io::{VertexOutput, FragmentOutput};
#import bevy_pbr::mesh_view_bindings::globals
#import bevy_pbr::pbr_fragment::pbr_input_from_standard_material;
#import bevy_pbr::pbr_functions::alpha_discard;
#import bevy_render::view::View


/// Keep up-to-date with the rust definition!
struct AuraMaterial {
    unused: f32,
}

@group(1) @binding(100) var<uniform> my_extended_material: AuraMaterial;
@group(0) @binding(0)   var<uniform> view: View;

// Colour picker tells us the values of the original..
// Darkish
// #CEAA4F
const GOLD = vec3f(0.807843, 0.666667, 0.309804);


const SPIKENUM: f32 = 9.0;
const SPIKELEN: f32 = 1.68;
const SPIKE_SPEED:f32 = 32.0;

const PI: f32 =  3.141592653589;
const TAU: f32 = 6.283185307179;

@fragment
fn fragment(in: VertexOutput,
    @builtin(front_facing) is_front: bool) -> @location(0) vec4<f32> {

    var uv = in.uv;
    uv = uv * 2.0 - 1.0; //normalise to 0 .. 1

    let time = globals.time;

    let feet_mask = sdCircle(uv, 0.3); // Get a mask for the area around our feet.

    // Move into polar coordinates.
    var st = vec2f(atan2(uv.x, uv.y), length(uv));
    let x = (st.x / PI) * SPIKENUM; // Divide the x coords by PI so they line up perfectly.


    // Make the spikes. 
    let f_x = fract(x);
    let f2_x = fract(1.0 - x);
    var m = min(f_x, f2_x);
    m = m * SPIKELEN - st.y;

    // Draw the spikes:
    var c = smoothstep(0.03, 0.9, m);
    var col = vec3f(c);

    // Mask out the area around the character's feet..
    col *= smoothstep(0.0, 0.08, feet_mask);

    // Because % with floats is a baaaaaaaad idea.
    let rate = i32(time * SPIKE_SPEED); //TODO: const SPIK_SPEED

    let idx: i32 = (rate % i32(SPIKENUM * 2.0)) - i32(SPIKENUM - 1.0) ;
    var x_clamp = -floor(x);
    let isDifferent = step(0.5, abs(f32(idx) - x_clamp));
    col *= mix(GOLD / 0.25, GOLD * 0.25, isDifferent);


    return vec4f(col, 1.0);
}

fn sdCircle(p: vec2f, r: f32) -> f32 {
    return length(p) - r;
}



