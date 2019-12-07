use std::process;
use std::io;
use std::io::prelude::*;

const MAX_PROGRAM: usize = 6000;

fn machine(input: i32, signal: i32, _program: &[i32; MAX_PROGRAM], total_instructions: usize) -> Option<i32> {
    let mut output: Option<i32> = None;
    let mut i : usize = 0;
    let mut program : [i32; MAX_PROGRAM] = [0; MAX_PROGRAM];
    for j in 0..total_instructions {
        program[j] = _program[j] as i32;
    }

    let mut first_time = true;

    while i < total_instructions && program[i] != 99 {
        let instruction = program[i] % 100;
        let modes = ((program[i] / 100) % 10, (program[i] / 1_000) % 10, (program[i] / 10_000) % 10);
        match instruction {
            1 => { // Sum OP
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
            2 => { // Multiplication OP
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
            3 => { // Input OP
                let input_number;
                if first_time {
                    input_number = input;
                    first_time = false;
                } else {
                    input_number = signal;
                }

                if modes.0 == 0 {
                    program[ program[i+1] as usize ] = input_number;
                } else {
                    program[i+1] = input_number;
                }
                i += 2;
            }
            4 => { // Output OP
                if modes.0 == 0 {
                    output = Some(program[ program[i+1] as usize ]);
                } else {
                    output = Some(program[i+1]);
                }
                i += 2;
            }
            5 => { // Jump-if-true
                let mut first_number = program[i+1];
                if modes.0 == 0 {
                    first_number = program[ first_number as usize ];
                }

                let mut second_number = program[i+2];
                if modes.1 == 0 {
                    second_number = program[ program[i+2] as usize ];
                }

                if first_number != 0 {
                    i = second_number as usize
                } else {
                    i += 3;
                }
            }
            6 => { // Jump-if-false
                let mut first_number = program[i+1];
                if modes.0 == 0 {
                    first_number = program[ first_number as usize ];
                }

                let mut second_number = program[i+2];
                if modes.1 == 0 {
                    second_number = program[ program[i+2] as usize ];
                }

                if first_number == 0 {
                    i = second_number as usize
                } else {
                    i += 3;
                }
            }
            7 => { // less than OP
                let mut first_number = program[i+1];
                if modes.0 == 0 {
                    first_number = program[ first_number as usize ];
                }

                let mut second_number = program[i+2];
                if modes.1 == 0 {
                    second_number = program[ program[i+2] as usize ];
                }
                if first_number < second_number {
                    program[  program[i+3] as usize ] = 1;
                } else {
                    program[  program[i+3] as usize ] = 0;
                }
                i += 4;
            }
            8 => { // less than OP
                let mut first_number = program[i+1];
                if modes.0 == 0 {
                    first_number = program[ first_number as usize ];
                }

                let mut second_number = program[i+2];
                if modes.1 == 0 {
                    second_number = program[ program[i+2] as usize ];
                }
                if first_number == second_number {
                    program[  program[i+3] as usize ] = 1;
                } else {
                    program[  program[i+3] as usize ] = 0;
                }
                i += 4;
            }
            _ => { println!("NOT REGISTERED OP!! {}", program[i]); process::exit(1)}
        }
    }
    return output;
}

fn main() {
    let mut program : [i32; MAX_PROGRAM] = [0; MAX_PROGRAM];
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

    let perms : [[i32; 5]; 120] = [[0, 1, 2, 3, 4], [0, 1, 2, 4, 3], [0, 1, 3, 2, 4], [0, 1, 3, 4, 2], [0, 1, 4, 2, 3], [0, 1, 4, 3, 2], [0, 2, 1, 3, 4], [0, 2, 1, 4, 3], [0, 2, 3, 1, 4], [0, 2, 3, 4, 1], [0, 2, 4, 1, 3], [0, 2, 4, 3, 1], [0, 3, 1, 2, 4], [0, 3, 1, 4, 2], [0, 3, 2, 1, 4], [0, 3, 2, 4, 1], [0, 3, 4, 1, 2], [0, 3, 4, 2, 1], [0, 4, 1, 2, 3], [0, 4, 1, 3, 2], [0, 4, 2, 1, 3], [0, 4, 2, 3, 1], [0, 4, 3, 1, 2], [0, 4, 3, 2, 1], [1, 0, 2, 3, 4], [1, 0, 2, 4, 3], [1, 0, 3, 2, 4], [1, 0, 3, 4, 2], [1, 0, 4, 2, 3], [1, 0, 4, 3, 2], [1, 2, 0, 3, 4], [1, 2, 0, 4, 3], [1, 2, 3, 0, 4], [1, 2, 3, 4, 0], [1, 2, 4, 0, 3], [1, 2, 4, 3, 0], [1, 3, 0, 2, 4], [1, 3, 0, 4, 2], [1, 3, 2, 0, 4], [1, 3, 2, 4, 0], [1, 3, 4, 0, 2], [1, 3, 4, 2, 0], [1, 4, 0, 2, 3], [1, 4, 0, 3, 2], [1, 4, 2, 0, 3], [1, 4, 2, 3, 0], [1, 4, 3, 0, 2], [1, 4, 3, 2, 0], [2, 0, 1, 3, 4], [2, 0, 1, 4, 3], [2, 0, 3, 1, 4], [2, 0, 3, 4, 1], [2, 0, 4, 1, 3], [2, 0, 4, 3, 1], [2, 1, 0, 3, 4], [2, 1, 0, 4, 3], [2, 1, 3, 0, 4], [2, 1, 3, 4, 0], [2, 1, 4, 0, 3], [2, 1, 4, 3, 0], [2, 3, 0, 1, 4], [2, 3, 0, 4, 1], [2, 3, 1, 0, 4], [2, 3, 1, 4, 0], [2, 3, 4, 0, 1], [2, 3, 4, 1, 0], [2, 4, 0, 1, 3], [2, 4, 0, 3, 1], [2, 4, 1, 0, 3], [2, 4, 1, 3, 0], [2, 4, 3, 0, 1], [2, 4, 3, 1, 0], [3, 0, 1, 2, 4], [3, 0, 1, 4, 2], [3, 0, 2, 1, 4], [3, 0, 2, 4, 1], [3, 0, 4, 1, 2], [3, 0, 4, 2, 1], [3, 1, 0, 2, 4], [3, 1, 0, 4, 2], [3, 1, 2, 0, 4], [3, 1, 2, 4, 0], [3, 1, 4, 0, 2], [3, 1, 4, 2, 0], [3, 2, 0, 1, 4], [3, 2, 0, 4, 1], [3, 2, 1, 0, 4], [3, 2, 1, 4, 0], [3, 2, 4, 0, 1], [3, 2, 4, 1, 0], [3, 4, 0, 1, 2], [3, 4, 0, 2, 1], [3, 4, 1, 0, 2], [3, 4, 1, 2, 0], [3, 4, 2, 0, 1], [3, 4, 2, 1, 0], [4, 0, 1, 2, 3], [4, 0, 1, 3, 2], [4, 0, 2, 1, 3], [4, 0, 2, 3, 1], [4, 0, 3, 1, 2], [4, 0, 3, 2, 1], [4, 1, 0, 2, 3], [4, 1, 0, 3, 2], [4, 1, 2, 0, 3], [4, 1, 2, 3, 0], [4, 1, 3, 0, 2], [4, 1, 3, 2, 0], [4, 2, 0, 1, 3], [4, 2, 0, 3, 1], [4, 2, 1, 0, 3], [4, 2, 1, 3, 0], [4, 2, 3, 0, 1], [4, 2, 3, 1, 0], [4, 3, 0, 1, 2], [4, 3, 0, 2, 1], [4, 3, 1, 0, 2], [4, 3, 1, 2, 0], [4, 3, 2, 0, 1], [4, 3, 2, 1, 0]];

    let mut max_signal = -9999999;
    for perm in perms.iter() {
        let mut signal = 0;
        for phase in perm.iter() {
            let ret = machine(*phase, signal, &program, total_instructions);
            match ret {
                None => { println!("Something went wrong. No output!"); break }
                Some(x) => { signal = x }
            }
        }
        if signal > max_signal {
            max_signal = signal
        }
    }
    println!("{}", max_signal);
}
