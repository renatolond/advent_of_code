use std::io;
use std::io::prelude::*;

fn main() {
    let mut result = 0;
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let mass: i64 = line_str.trim().parse().unwrap();
        let fuel = (mass as f64 / 3.0).trunc() as i64 - 2;
        if fuel > 0 {
            result += fuel;
        }
        let mut new_mass = fuel;
        let mut new_fuel;
        loop {
            if new_mass == 0 {
                break
            }
            new_fuel = (new_mass as f64 / 3.0).trunc() as i64 - 2;
            new_mass = 0;
            if new_fuel > 0 {
                result += new_fuel;
                new_mass = new_fuel;
            }
        }
    }
    println!("{}", result);
}

