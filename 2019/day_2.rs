use std::io;
use std::io::prelude::*;

fn main() {
    let mut program : [usize; 6000] = [0; 6000];
    let mut total_instructions = 0;
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let mut i = 0;
        for number in line_str.split(',') {
            program[i] = number.parse::<usize>().unwrap();
            i = i+1;
        }
        total_instructions = i;
    }
    let mut i : usize = 0;
    while i < total_instructions && program[i] != 99 {
        match program[i] {
            1 => {
                let first_number = program[ program[i+1] ];
                let second_number = program[ program[i+2] ];
                program[  program[i+3] ] = first_number + second_number;
            }
            2 => {
                let first_number = program[ program[i+1] ];
                let second_number = program[ program[i+2] ];
                program[  program[i+3] ] = first_number * second_number;
            }
            _ => { println!("NOT REGISTERED OP!! {}", program[i]); }
        }

        i += 4;
    }

    for j in 0..total_instructions {
        println!("{}", program[j]);
    }
    println!("{}", program[0]);
}


