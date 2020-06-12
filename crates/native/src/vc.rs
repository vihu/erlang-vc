use crate::atoms::{ok, equal, caused, effect_of, concurrent};
use rustler::{Atom, Env, ResourceArc};
use vectorclock::VectorClock;
use vectorclock::TemporalRelation::{Equal, Caused, EffectOf, Concurrent};

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

#[rustler::nif(name = "incremented")]
fn incremented(vc_resource: ResourceArc<VCResource>, value: String) -> (Atom, ResourceArc<VCResource>) {
    let vc_ref = vc_resource.vc.clone();

    let res = ResourceArc::new(VCResource {
        vc: vc_ref.incremented(value)
    });

    (ok(), res)
}

#[rustler::nif(name = "is_equal")]
fn is_equal(vc_resource1: ResourceArc<VCResource>, vc_resource2: ResourceArc<VCResource>) -> bool {
    let vc1 = vc_resource1.vc.clone();
    let vc2 = vc_resource2.vc.clone();

    vc1 == vc2
}

#[rustler::nif(name = "temporal_relation")]
fn temporal_relation(vc_resource1: ResourceArc<VCResource>, vc_resource2: ResourceArc<VCResource>) -> Atom {
    let vc1 = vc_resource1.vc.clone();
    let vc2 = vc_resource2.vc.clone();

    match vc1.temporal_relation(&vc2) {
        Equal => equal(),
        Caused => caused(),
        EffectOf => effect_of(),
        Concurrent => concurrent()
    }
}

#[rustler::nif(name = "merge_with")]
fn merge_with(vc_resource1: ResourceArc<VCResource>, vc_resource2: ResourceArc<VCResource>) -> (Atom, ResourceArc<VCResource>) {
    let vc1 = vc_resource1.vc.clone();
    let vc2 = vc_resource2.vc.clone();

    let res = ResourceArc::new(VCResource {
        vc: vc1.merge_with(&vc2)
    });

    (ok(), res)
}

#[rustler::nif(name = "to_vec")]
fn to_vec(vc_resource: ResourceArc<VCResource>) -> Vec<(String, u64)> {
    let vc = vc_resource.vc.clone();

    vc.to_vec()
}
