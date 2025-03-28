/// ***************************** ///
/// THIS IS THE DEFAULT 2D SHADER ///
/// You can always get back to this with `python3 scripts/reset-2d.py` ///
/// ***************************** ///

#import bevy_sprite::mesh2d_view_bindings::globals 
#import shadplay::shader_utils::common::{PI, TAU, NEG_HALF_PI, shader_toy_default, rotate2D, TWO_PI, intoPolar}
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

@group(2) @binding(0) var<uniform> mouse: YourShader2D;
struct YourShader2D{
    mouse_pos : vec2f,
}

const SPEED:f32 = 1.0;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var uv = normalize_center(in.uv.xy);
    let uv0 = uv;
    let d0 = length(uv0);
    let t = globals.time * SPEED;
    var output = vec3f(0.0, 0.0, 0.0);
// -----------------------------------------------------    
    let r = 0.8; 
    var inside = step(r, d0);
    var outside = step(-r, -d0);

    var d = r - length(uv);
    output += vec3f(0.0, 1.0*pow(0.02/abs(d), 1.8), 1.0 * pow(0.02/abs(d),1.2)) ;
    
    // uv = uv * rotate2D(t * 0.05);
    var a = 0.4 * (abs(uv.x) - r);
    a *= 1.0/(1.0 + 2.0 * abs(uv.x));
    var l = 0.02 * outside;
    d = uv.y + a * sin(uv.x * 4.0 * TAU - t * 8.0);
    output += vec3f(0.0, 1.0*pow(l/abs(d), 1.8), 1.0 * pow(l/abs(d),1.2)) ;

    

    return vec4f(output, 0.3);
}

fn normalize_center(p: vec2<f32>) -> vec2<f32> {
    var uv = (p * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    uv.x *= resolution.x / resolution.y;
    return uv;
}
    
fn palette(t: f32) -> vec3<f32> {
    var a = vec3f(0.5, 0.5, 0.5);
    let b = vec3f(0.5, 0.5, 0.5);
    let c = vec3f(1.0, 1.0, 1.0);
    let d = vec3f(0.263, 0.453, 0.63);
    var col = a + 0.8 * b * cos(TAU * (c * t + d));
    return col;
}

