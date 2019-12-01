use std::io;
use std::io::prelude::*;

fn main() {
    let mut result = 0;
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let mass: i32 = line_str.trim().parse().unwrap();
        let fuel = (mass as f32 / 3.0).trunc() as i32 - 2;
        result += fuel;
    println!("{}", fuel);
    }
    println!("{}", result);
}

