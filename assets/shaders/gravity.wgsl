/// ***************************** ///
/// THIS IS THE DEFAULT 2D SHADER ///
/// You can always get back to this with `python3 scripts/reset-2d.py` ///
/// ***************************** ///

#import bevy_sprite::mesh2d_view_bindings::globals 
#import shadplay::shader_utils::common::{PI, TAU, NEG_HALF_PI, shader_toy_default, rotate2D, TWO_PI, intoPolar}
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 0.2;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var uv = normalize_center(in.uv.xy);
    let uv0 = uv;
    let d0 = length(uv0);
// -----------------------------------------------------    
    let t = globals.time * SPEED;
    let g0 = 16.0;
    let dg = 24.0;
    // -----------------------------------------------------
    uv *= 4.0;

    var p1 = vec2f(0.0,0.0); 
    var m1 = 16.0;
    var g1 = gravity(p1, m1);

    var p2 = uv + vec2f(-2.0,-2.0); 
    var m2 = 16.0;
    var g2 = gravity(p2, m2);
    
    var color = vec3f(0.0);
    var uv1 = uv + p1;
    color.x += lines(uv.x * g1) + lines(uv.y * g1);

    return vec4f(color, 0.3);
}

fn gravity(p: vec2<f32>, m: f32) -> f32 {
    var d = length(p);
    var g = 16.0 + m * 1.0 / (0.1 + 0.3 * d);
    return g;
    /* var color = vec3f(0.0);
    color.x = lines(p.x * g) + lines(p.y*g);
    return color; */
}

fn lines(f: f32) -> f32 {
    var h = (1.0 + cos(f)) / 2.0;
    h = pow(0.03/h, 1.5);
    return h;
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

