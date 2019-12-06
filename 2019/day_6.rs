//use std::process;
use std::io;
use std::io::prelude::*;
use std::convert::TryInto;

const NUM_PLANETS : usize = 30;

struct Planet {
    name: String,
    orbiting: Vec<usize>,
    orbiters: Vec<usize>,
    accum: i32
}
fn main() {
    let mut planets : Vec<Planet> = Vec::new();
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let orbit_desc : Vec<&str>  = line_str.split(')').collect();
        let planet_center = orbit_desc[0].to_string();
        let planet_orbiter = orbit_desc[1].to_string();
        let mut planet_center_idx : i32 = -1;
        let mut planet_orbiter_idx : i32 = -1;
        for i in 0..planets.len() {
            if planets[i].name == planet_center {
                planet_center_idx = i.try_into().unwrap();
            }
            if planets[i].name == planet_orbiter {
                planet_orbiter_idx = i.try_into().unwrap();
            }
        }
        if planet_center_idx == -1 {
            let idx = planets.len();
            planet_center_idx = idx.try_into().unwrap();
            planets.push(Planet { name: planet_center, orbiting: Vec::new(), orbiters: Vec::new(), accum: -1 });
        }
        if planet_orbiter_idx == -1 {
            let idx = planets.len();
            planet_orbiter_idx = idx.try_into().unwrap();
            planets.push( Planet { name: planet_orbiter, orbiting: Vec::new(), orbiters: Vec::new(), accum: -1 });
        }

        {
            let ref mut planet_center_s : Planet;
            planet_center_s = &mut planets[planet_center_idx as usize];
            planet_center_s.orbiters.push(planet_orbiter_idx.try_into().unwrap());
        }
        {
            let ref mut planet_orbiter_s : Planet;
            planet_orbiter_s = &mut planets[planet_orbiter_idx as usize];
            planet_orbiter_s.orbiting.push(planet_center_idx.try_into().unwrap());
        }
    }

    //for i in 0..planets.len() {
    //    let none = "NONE".to_string();
    //    let ref planet;
    //    if orbits[i] == -1 {
    //        planet = &none;
    //    } else {
    //        planet = &planets[orbits[i] as usize];
    //    }
    //    println!("{}: {} {}", planets[i], planet, pointing[i]);
    //}
    //println!("{}", planets.len());
}
