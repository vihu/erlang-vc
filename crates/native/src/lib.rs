extern crate rustler;

use rustler::{Env, Term};

mod atoms;
mod vc;

fn load(env: Env, _: Term) -> bool {
    vc::load(env);

    true
}

rustler::init!(
    "erlang_vc",
    [
        // PedersenGens API
        vc::new,
        vc::incremented,
        vc::is_equal,
        vc::temporal_relation,
        vc::merge_with,
        vc::to_vec,
    ],
    load = load
);
