use std::mem;

// Coerce a bit pattern to a single-precision float.
fn main() {
    let n: i32 = 1234567890_i32;
    let f: f32 = unsafe { mem::transmute(n) };
    println!("The bits {:x} as a float represent: {:.6}", n, f);
}
