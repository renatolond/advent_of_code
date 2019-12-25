use std::io;
use std::io::prelude::*;
use std::process;
use std::convert::TryInto;

fn get_pattern(idx : usize, multiplier : usize) -> i64 {
    let pattern : [i64; 4] = [0, 1, 0, -1];
    let size = ((idx + 1) % (pattern.len() * multiplier));
    return pattern[size / multiplier];
}

fn main() {
    let stdin = io::stdin();
    let mut lines_iter = stdin.lock().lines();
    let mut numbers : Vec<char>;
    let result = lines_iter.next().unwrap().unwrap().parse::<String>();
    match result {
        Ok(s) => { numbers = s.chars().collect() }
        _ => { println!("Oh no."); process::exit(1); }
    }


    let mut phase = 0;

    loop {
        let mut output_numbers : Vec<char> = numbers.clone();

        for i in 0..output_numbers.len() {
            let mut calculation : i64 = 0;

            let multiplier = i + 1;
            for j in 0..numbers.len() {
                let digit : i64 = numbers[j].to_digit(10).unwrap().try_into().unwrap();
                calculation += digit * get_pattern(j, multiplier);
            }
            output_numbers[i] = ((calculation.abs() % 10) as u8 + b'0') as char;
        }

        numbers = output_numbers.clone();
        phase += 1;
        if phase >= 100 {
            break;
        }
    }
    println!("{}{}{}{}{}{}{}{}", numbers[0], numbers[1], numbers[2], numbers[3], numbers[4], numbers[5], numbers[6], numbers[7]);
}
