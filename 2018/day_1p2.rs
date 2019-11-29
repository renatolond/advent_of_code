use std::io;
use std::io::prelude::*;
use std::collections::HashSet;
use std::process;

fn main() {
    let mut result = 0;
    let mut frequencies = HashSet::new();
    frequencies.insert(result);
    let mut numbers = Vec::new();
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let n: i32 = line_str.trim().parse().unwrap();
        numbers.push(n);
    }

    let mut n = 0;
    loop {
        result += numbers[n];
        if frequencies.contains(&result) {
            println!("{}", result);
            process::exit(0)
        } else {
            frequencies.insert(result);
        }
        n += 1;
        if n >= numbers.len() {
            n = 0
        }
    }
}
