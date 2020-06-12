use crate::atoms::ok;
use rustler::{Atom, Env, ResourceArc};
use vectorclock::VectorClock;

/// Struct to hold VectorClock
pub struct VCResource {
    pub vc: VectorClock<String>
}

pub fn load(env: Env) -> bool {
    rustler::resource!(VCResource, env);
    true
}

#[rustler::nif(name = "new")]
fn new() -> (Atom, ResourceArc<VCResource>) {
    let res = ResourceArc::new(VCResource {
        vc: VectorClock::new()
    });

    (ok(), res)
}
