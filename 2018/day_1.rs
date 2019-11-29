use std::io;
use std::io::prelude::*;

fn main() {
    let mut result = 0;
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let n: i32 = line_str.trim().parse().unwrap();
        result += n;
    }
    println!("{}", result);
}
