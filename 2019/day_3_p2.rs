use std::io;
use std::io::prelude::*;
use std::process;

const PORT_X: usize = 10000;
const PORT_Y: usize = 10000;

const DIMENSIONS: usize = 18000;

fn main() {
    let mut circuit : Vec<Vec<i8>> = Vec::new();
    let mut wire1_dist : Vec<Vec<i32>> = Vec::new();
    let mut wire2_dist : Vec<Vec<i32>> = Vec::new();
    println!("Filling 2d array up");
    for _ in 0..DIMENSIONS {
        circuit.push(vec![0; DIMENSIONS]);
        wire1_dist.push(vec![0; DIMENSIONS]);
        wire2_dist.push(vec![0; DIMENSIONS]);
    }
    println!("Done!");
    let mut wire = 1;
    for line in io::stdin().lock().lines() {
        let mut x = PORT_X;
        let mut y = PORT_Y;

        let line_str: String = line.unwrap();
        let mut dist = 0;
        for bend in line_str.split(",") {
            let mut command = bend.to_string();
            let movement : i32 = command.split_off(1).parse().unwrap();

            let dir_y : i32;
            let dir_x : i32;
            match command.as_ref() {
                "U" => { dir_y = 1; dir_x = 0; }
                "D" => { dir_y = -1; dir_x = 0; }
                "L" => { dir_y = 0; dir_x = 1; }
                "R" => { dir_y = 0; dir_x = -1; }
                _ => { println!("Something is not right! command is {}", command); process::exit(1) }
            }

            for _ in 0..movement {
                if circuit[x][y] == 0 || circuit[x][y] == wire {
                    circuit[x][y] = wire;
                } else {
                    circuit[x][y] = -1;
                }

                if wire == 1 {
                    wire1_dist[x][y] = dist;
                } else {
                    wire2_dist[x][y] = dist;
                }

                x = (x as i32 + dir_x) as usize;
                y = (y as i32 + dir_y) as usize;
                dist += 1;
            }
        }

        wire += 1
    }

    let mut smaller_distance : i32 = 99999999;
    // let mut collisions : Vec::<(usize, usize)> = Vec::new();
    for i in 0..DIMENSIONS {
        for j in 0..DIMENSIONS {
            if i == PORT_X && j == PORT_Y {
                continue;
            }
            if circuit[i][j] == -1 {
                let distance : i32 = wire1_dist[i][j] + wire2_dist[i][j];
                if distance < smaller_distance {
                    smaller_distance = distance
                }
//                collisions.push( (i, j) );
            }
        }
    }

    println!("{}", smaller_distance);
}
