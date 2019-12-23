use std::process;
use std::io;
use std::io::prelude::*;
use std::convert::TryInto;
use std::collections::HashSet;

use regex::Regex;
#[derive(Copy, Clone)]
struct Xyz {
    x: i64,
    y: i64,
    z: i64
}

#[derive(Copy, Clone)]
struct Moon {
    pos: Xyz,
    velocity: Xyz,
    energy: i64
}

fn parse_line(s: &String) -> Moon {
    let r = Regex::new(r"^<x=(-?\d+), y=(-?\d+), z=(-?\d+)>$").unwrap();
    let caps = r.captures(s).unwrap();
    let x : i64 = caps.get(1).unwrap().as_str().parse().ok().unwrap();
    let y : i64= caps.get(2).unwrap().as_str().parse().ok().unwrap();
    let z : i64 = caps.get(3).unwrap().as_str().parse().ok().unwrap();

    Moon { pos: Xyz { x: x, y: y, z: z }, velocity: Xyz { x: 0, y: 0, z: 0 }, energy: 0 }
}

fn main() {
    let stdin = io::stdin();
    let mut lines_iter = stdin.lock().lines();

    let io = parse_line(&lines_iter.next().unwrap().unwrap());
    let europa = parse_line(&lines_iter.next().unwrap().unwrap());
    let ganymede = parse_line(&lines_iter.next().unwrap().unwrap());
    let callisto = parse_line(&lines_iter.next().unwrap().unwrap());

    let mut moons : Vec<Moon> = Vec::new();
    moons.push(io);
    moons.push(europa);
    moons.push(ganymede);
    moons.push(callisto);

    let mut previous_steps = HashSet::new();
    let mut steps = 0;
    loop {
        // serialize state
        let mut state = "".to_string();
        for moon_idx in 0..4 {
            state = format!("{}|{},{}",state,moons[moon_idx].pos.x,moons[moon_idx].velocity.x);
        }
        if previous_steps.contains(&state) {
            println!("Stop! Universe x reset in step {} : {}", steps, state);
            break;
        }
        previous_steps.insert(state);

        for moon_idx in 0..4 {
            for other_moon_idx in moon_idx+1..4 {
                if moon_idx == other_moon_idx {
                    continue
                }

                // X
                if moons[moon_idx].pos.x > moons[other_moon_idx].pos.x {
                    moons[moon_idx].velocity.x -= 1;
                    moons[other_moon_idx].velocity.x += 1;
                } else if moons[moon_idx].pos.x < moons[other_moon_idx].pos.x {
                    moons[moon_idx].velocity.x += 1;
                    moons[other_moon_idx].velocity.x -= 1;
                }
            }
        }

        for moon_idx in 0..4 {
            moons[moon_idx].pos.x += moons[moon_idx].velocity.x;
        }
        steps += 1;
    }
    steps = 0;
    previous_steps = HashSet::new();
    loop {
        // serialize state
        let mut state = "".to_string();
        for moon_idx in 0..4 {
            state = format!("{}|{},{}",state,moons[moon_idx].pos.y,moons[moon_idx].velocity.y);
        }
        if previous_steps.contains(&state) {
            println!("Stop! Universe y reset in step {} : {}", steps, state);
            break;
        }
        previous_steps.insert(state);

        for moon_idx in 0..4 {
            for other_moon_idx in moon_idx+1..4 {
                if moon_idx == other_moon_idx {
                    continue
                }

                // X
                if moons[moon_idx].pos.y > moons[other_moon_idx].pos.y {
                    moons[moon_idx].velocity.y -= 1;
                    moons[other_moon_idx].velocity.y += 1;
                } else if moons[moon_idx].pos.y < moons[other_moon_idx].pos.y {
                    moons[moon_idx].velocity.y += 1;
                    moons[other_moon_idx].velocity.y -= 1;
                }
            }
        }

        for moon_idx in 0..4 {
            moons[moon_idx].pos.y += moons[moon_idx].velocity.y;
        }
        steps += 1;
    }
    steps = 0;
    previous_steps = HashSet::new();
    loop {
        // serialize state
        let mut state = "".to_string();
        for moon_idx in 0..4 {
            state = format!("{}|{},{}",state,moons[moon_idx].pos.z,moons[moon_idx].velocity.z);
        }
        if previous_steps.contains(&state) {
            println!("Stop! Universe z reset in step {} : {}", steps, state);
            break;
        }
        previous_steps.insert(state);

        for moon_idx in 0..4 {
            for other_moon_idx in moon_idx+1..4 {
                if moon_idx == other_moon_idx {
                    continue
                }

                // Z
                if moons[moon_idx].pos.z > moons[other_moon_idx].pos.z {
                    moons[moon_idx].velocity.z -= 1;
                    moons[other_moon_idx].velocity.z += 1;
                } else if moons[moon_idx].pos.z < moons[other_moon_idx].pos.z {
                    moons[moon_idx].velocity.z += 1;
                    moons[other_moon_idx].velocity.z -= 1;
                }
            }
        }
        for moon_idx in 0..4 {
            moons[moon_idx].pos.z += moons[moon_idx].velocity.z;
        }
        steps += 1;
    }
}
