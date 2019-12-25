use std::io;
use std::io::prelude::*;
use std::process;
use std::convert::TryInto;

const PATTERN : [i64; 4] = [0, 1, 0, -1];
fn get_pattern(idx : usize, multiplier : usize) -> i64 {
    let size = (idx + 1) % (PATTERN.len() * multiplier);
    return PATTERN[size / multiplier];
}

fn main() {
    let stdin = io::stdin();
    let mut lines_iter = stdin.lock().lines();
    let temp_numbers : Vec<char>;
    let mut numbers : Vec<i64> = Vec::new();
    let result = lines_iter.next().unwrap().unwrap().parse::<String>();
    match result {
        Ok(s) => { temp_numbers = s.chars().collect() }
        _ => { println!("Oh no."); process::exit(1); }
    }

    println!("Start multiplying");
    {
        let repeat = temp_numbers.len();
        for _ in 0..10_000 {
            for j in 0..repeat {
                numbers.push(temp_numbers[j].to_digit(10).unwrap().try_into().unwrap());
            }
        }
    }
    println!("Finished multiplying. Contains {} elements", numbers.len());


    let mut phase = 0;

    let offset_str = format!("{}{}{}{}{}{}{}{}", numbers[0], numbers[1], numbers[2], numbers[3], numbers[4], numbers[5], numbers[6], numbers[7]);
    let offset = offset_str.parse::<usize>().unwrap();

    loop {
        let mut output_numbers : Vec<i64> = numbers.clone();

        for i in 0..output_numbers.len() {
            if i % 1000 == 0 {
                println!("Calculating digit {}", i);
            }
            let mut calculation : i64 = 0;

            let multiplier = i + 1;
            for j in 0..numbers.len() {
                let p = get_pattern(j, multiplier);
                if p == 0 {
                    continue;
                }
                calculation += numbers[j] * p;
            }
            output_numbers[i] = calculation.abs() % 10;
        }

        numbers = output_numbers.clone();
        phase += 1;
        println!("Calculated phase {}", phase);
        if phase >= 100 {
            break;
        }
    }
    println!("{}{}{}{}{}{}{}{}", numbers[offset+0], numbers[offset+1], numbers[offset+2], numbers[offset+3], numbers[offset+4], numbers[offset+5], numbers[offset+6], numbers[offset+7]);
}

