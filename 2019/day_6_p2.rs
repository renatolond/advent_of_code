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
    let mut start : usize = 99999;
    let mut end : usize = 99999;
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
        }
        {
            let ref mut planet_orbiter_s : Planet;
            planet_orbiter_s = &mut planets[planet_orbiter_idx.unwrap()];
            planet_orbiter_s.orbiting = planet_center_idx;
            if planet_orbiter_s.name == "YOU" {
                start = planet_orbiter_idx.unwrap();
            }
            if planet_orbiter_s.name == "SAN" {
                end = planet_orbiter_idx.unwrap();
            }
        }
    }
    let mut visited = vec![false; planets.len()];

    let mut curr_state : (usize, i32) = (start, 0);
    let mut to_visit : VecDeque<(usize, i32)> = VecDeque::new();
    loop {
        let (curr_idx, jumps) = curr_state;
        if curr_idx == end {
            break
        }
        println!("Looking at {}", planets[curr_idx].name);

        {
            let ref mut curr_planet : Planet = planets[curr_idx];
            if curr_planet.orbiting != None {
                if !visited[curr_planet.orbiting.unwrap()] {
                    to_visit.push_back((curr_planet.orbiting.unwrap(), jumps+1));
                }
            }
            for i in curr_planet.orbiters.iter() {
                if !visited[*i] {
                    to_visit.push_back((*i, jumps+1));
                }
            }

        }
        visited[curr_idx] = true;

        if to_visit.is_empty() {
            break
        }
        curr_state = to_visit.pop_front().unwrap();
    }

    {
        let (curr_idx, jumps) = curr_state;
        println!("{}", jumps - 2);
    }
}
