use std::process;
use std::io;
use std::io::prelude::*;

fn main() {
    let mut program : [i32; 6000] = [0; 6000];
    let mut total_instructions = 0;
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let mut i = 0;
        for number in line_str.split(',') {
            program[i] = number.parse::<i32>().unwrap();
            i = i+1;
        }
        total_instructions = i;
    }
    let mut i : usize = 0;
    while i < total_instructions && program[i] != 99 {
        let instruction = program[i] % 100;
        let modes = ((program[i] / 100) % 10, (program[i] / 1_000) % 10, (program[i] / 10_000) % 10);
        match instruction {
            1 => {
                let mut first_number = program[i+1];
                if modes.0 == 0 {
                    first_number = program[ first_number as usize ];
                }

                let mut second_number = program[i+2];
                if modes.1 == 0 {
                    second_number = program[ program[i+2] as usize ];
                }
                program[  program[i+3] as usize ] = first_number + second_number;
                i += 4;
            }
            2 => {
                let mut first_number = program[i+1];
                if modes.0 == 0 {
                    first_number = program[ first_number as usize ];
                }

                let mut second_number = program[i+2];
                if modes.1 == 0 {
                    second_number = program[ program[i+2] as usize ];
                }
                program[  program[i+3] as usize ] = first_number * second_number;
                i += 4;
            }
            3 => {
                // FOR THE DIAGNOSTIC
                let input_number = 1;
                if modes.0 == 0 {
                    program[ program[i+1] as usize ] = input_number;
                } else {
                    program[i+1] = input_number;
                }
                i += 2;
            }
            4 => {
                if modes.0 == 0 {
                    println!("{}", program[ program[i+1] as usize ]);
                } else {
                    println!("{}", program[i+1]);
                }
                i += 2;
            }
            _ => { println!("NOT REGISTERED OP!! {}", program[i]); process::exit(1)}
        }
    }
}
