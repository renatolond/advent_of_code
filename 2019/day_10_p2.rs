use std::process;
use std::io;
use std::io::prelude::*;
use std::cmp::Ordering;

const MAX_SIDE : usize = 1000;

static mut ASTEROID_FIELD : [[usize; MAX_SIDE]; MAX_SIDE] = [[MAX_SIDE+1; MAX_SIDE]; MAX_SIDE];
static mut ASTEROID_POSITIONS : Vec<(usize, usize)> = Vec::new();

fn decomposed_distance(asteroid : (usize, usize), other_asteroid : (usize, usize)) -> (i32, i32) {
    let mut pos : (i32, i32) = (0, 0);
    pos.0 = other_asteroid.0 as i32 - asteroid.0 as i32;
    pos.1 = other_asteroid.1 as i32 - asteroid.1 as i32;
    return pos;
}

struct AsteroidInfo {
    angle: f64,
    distance: f64,
    idx: usize,
    destroyed: bool
}

unsafe fn real_main() {
    let mut row = 0;
    let mut asteroid_idx = 0;
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let mut col = 0;
        for pos in line_str.chars() {
            if pos == '#' {
                ASTEROID_FIELD[row][col] = ASTEROID_POSITIONS.len();
                if row == 21 && col == 20 {
                    asteroid_idx = ASTEROID_POSITIONS.len()
                }
                ASTEROID_POSITIONS.push((row, col));
            }
            col = col+1;
        }
        row = row + 1;
    }
    // for i in 0..dimensions {
    //     for j in 0..dimensions {
    //         print!("{:4} ", ASTEROID_FIELD[i][j]);
    //     }
    //     println!("");
    // }

    let mut max_asteroids = 0;

    //println!("{}", ASTEROID_POSITIONS.len());
    let mut can_see = vec![true; ASTEROID_POSITIONS.len()];
    let asteroid = ASTEROID_POSITIONS[asteroid_idx];

    can_see[asteroid_idx] = false;

    let mut ordered_asteroids : Vec<AsteroidInfo> = Vec::new();
    //println!("checking asteroid {} {:?}", asteroid_idx, asteroid);
    for other_asteroid_idx in 0..ASTEROID_POSITIONS.len() {
        if other_asteroid_idx == asteroid_idx {
            continue
        }
        let other_asteroid = ASTEROID_POSITIONS[other_asteroid_idx];
        let dist = decomposed_distance(asteroid, other_asteroid);
        let euclid_1 = (((dist.0*dist.0) + (dist.1*dist.1)) as f64).sqrt();
        let euclid_2 = (1.0 as f64).sqrt();
        let mut angle = ((dist.0 as f64)/(euclid_1 * euclid_2)).acos();
        let mut angle_bef = angle;
        if dist.1 < 0 { // correct acos
            angle *= -1.0;
        }

        angle *= -1.0;

        angle -= std::f64::consts::PI; // make top 0
        if angle < 0.0 {
            angle += 2.0*std::f64::consts::PI;
        }

        ordered_asteroids.push(AsteroidInfo { angle: angle, distance: euclid_1, idx: other_asteroid_idx, destroyed: false });
        //println!("Angle for {:?} ({:?}) is: {}", other_asteroid, dist, angle);

        //let mut pos : (i32, i32)= (other_asteroid.0 as i32, other_asteroid.1 as i32);
        //pos.0 += dist.0;
        //pos.1 += dist.1;
        ////println!("Looking at the vector {:?} {:?}", other_asteroid, dist);
        //loop {
        //    if pos.0 >= dimensions as i32 || pos.1 >= dimensions as i32 || pos.0 < 0 || pos.1 < 0 {
        //        break
        //    }

        //    if ASTEROID_FIELD[pos.0 as usize][pos.1 as usize] < MAX_SIDE {
        //        let idx = ASTEROID_FIELD[pos.0 as usize][pos.1 as usize];
        //        can_see[idx] = false;
        //        //println!("Can't see {:?} because of {:?}", ASTEROID_POSITIONS[idx], other_asteroid);
        //    }

        //    pos.0 += dist.0;
        //    pos.1 += dist.1;
        //}
    }

    ordered_asteroids.sort_by(|a, b| {
        match a.angle.partial_cmp(&b.angle).unwrap() {
            Ordering::Equal => a.distance.partial_cmp(&b.distance).unwrap(),
            other => other
        }
    });

    let mut asteroids_destroyed = 0;
    let mut i = 0;
    loop {
        if asteroids_destroyed >= ordered_asteroids.len() {
            break;
        }

        {
            let mut to_be_destroyed = &mut ordered_asteroids[i];
            while to_be_destroyed.destroyed == true {
                i += 1;
                if i >= ordered_asteroids.len() {
                    i = 0
                }
                to_be_destroyed = &mut ordered_asteroids[i];
            }

            to_be_destroyed.destroyed = true;
            asteroids_destroyed += 1;
        }
        let destroyed_asteroid = &ordered_asteroids[i];
        println!("Asteroid {}: {:?}", asteroids_destroyed, ASTEROID_POSITIONS[destroyed_asteroid.idx]);

        loop {
            i += 1;
            if i >= ordered_asteroids.len() {
                i = 0
            }
            let next_asteroid = &ordered_asteroids[i];
            if (next_asteroid.angle - destroyed_asteroid.angle).abs() > 0.0000001 {
                break;
            }
        }
    }

    for asteroid in ordered_asteroids.iter() {
       println!("{} {:?}", asteroid.angle, ASTEROID_POSITIONS[asteroid.idx])
    }

    //let seeing = can_see.iter().filter(|x| **x == true).count();
    ////println!("{:?} {}", asteroid, seeing);
    //if seeing > max_asteroids {
    //    println!("max at #{:?}, with {}", asteroid, seeing);
    //    max_asteroids = seeing;
    //}
    println!("{}", max_asteroids);
}

fn main() {
    unsafe { real_main() }
}
