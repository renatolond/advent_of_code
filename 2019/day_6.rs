use std::process;
use std::io;
use std::io::prelude::*;
use std::convert::TryInto;
use std::collections::VecDeque;

struct Planet {
    name: String,
    orbiting: Option<usize>,
    orbiters: Vec<usize>,
    accum: i32
}
fn main() {
    let mut planets : Vec<Planet> = Vec::new();
    let mut max_orbiters = 0;
    let mut start : usize = 999;
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let orbit_desc : Vec<&str>  = line_str.split(')').collect();
        let planet_center = orbit_desc[0].to_string();
        let planet_orbiter = orbit_desc[1].to_string();
        let mut planet_center_idx : Option<usize> = None;
        let mut planet_orbiter_idx : Option<usize> = None;
        for i in 0..planets.len() {
            if planets[i].name == planet_center {
                planet_center_idx = i.try_into().unwrap();
            }
            if planets[i].name == planet_orbiter {
                planet_orbiter_idx = i.try_into().unwrap();
            }
        }
        if planet_center_idx == None {
            let idx = planets.len();
            planet_center_idx = Some(idx.try_into().unwrap());
            planets.push(Planet { name: planet_center, orbiting: None, orbiters: Vec::new(), accum: 0 });
        }
        if planet_orbiter_idx == None {
            let idx = planets.len();
            planet_orbiter_idx = Some(idx.try_into().unwrap());
            planets.push( Planet { name: planet_orbiter, orbiting: None, orbiters: Vec::new(), accum: 0 });
        }

        {
            let ref mut planet_center_s : Planet;
            planet_center_s = &mut planets[planet_center_idx.unwrap()];
            planet_center_s.orbiters.push(planet_orbiter_idx.unwrap().try_into().unwrap());
            if planet_center_s.orbiters.len() > max_orbiters {
                max_orbiters = planet_center_s.orbiters.len();
            }

            if planet_center_s.name == "COM" {
                start = planet_center_idx.unwrap();
            }
        }
        {
            let ref mut planet_orbiter_s : Planet;
            planet_orbiter_s = &mut planets[planet_orbiter_idx.unwrap()];
            planet_orbiter_s.orbiting = planet_center_idx;
        }
    }
    let mut visited = vec![false; planets.len()];

    let mut curr_idx = start;
    let mut to_visit : VecDeque<usize> = VecDeque::new();
    loop {
        if visited[curr_idx] {
            println!("Oh noes.");
            process::exit(1)
        }
        println!("Looking at {}", planets[curr_idx].name);
        let accum;
        match planets[curr_idx].orbiting {
            Some(idx) => { accum = planets[idx].accum + 1}
            None => { accum = 0 }
        }

        {
            let ref mut curr_planet : Planet = planets[curr_idx];
            for i in curr_planet.orbiters.iter() {
                to_visit.push_back(*i);
            }

            curr_planet.accum = accum;
        }
        visited[curr_idx] = true;

        if to_visit.is_empty() {
            break
        }
        curr_idx = to_visit.pop_front().unwrap();
    }

    let mut orbits = 0;
    for i in 0..planets.len() {
        orbits += planets[i].accum;
        println!("{} {}", planets[i].name, planets[i].accum);
    }

    println!("{}", orbits);
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
