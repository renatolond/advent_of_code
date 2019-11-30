use std::io;
use std::io::prelude::*;

use regex::Regex;

fn parse_line(s: &String) -> Option<(i32, usize, usize, usize, usize)> {
    let r = Regex::new(r"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)").unwrap();
    let caps = r.captures(s).unwrap();
    let id = caps.get(1)?.as_str().parse().ok()?;
    let x = caps.get(2)?.as_str().parse().ok()?;
    let y = caps.get(3)?.as_str().parse().ok()?;
    let width = caps.get(4)?.as_str().parse().ok()?;
    let height = caps.get(5)?.as_str().parse().ok()?;

    Some((id, x, y, width, height))
}

fn main() {
    let mut fabric : [[i32; 1000]; 1000] = [[0; 1000]; 1000];
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let (id, x, y, width, height) = parse_line(&line_str).unwrap();
        for i in x..x+width {
            for j in y..y+height {
                if fabric[i][j] == 0 {
                    fabric[i][j] = id;
                } else {
                    fabric[i][j] = -1;
                }
            }
        }
    }
    let mut claimed = 0;
    for i in 0..1000 {
        for j in 0..1000 {
            if fabric[i][j] == -1 {
                claimed += 1
            }
        }
    }
    println!("{}", claimed);
}
