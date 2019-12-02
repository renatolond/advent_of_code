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
    let mut dup_program : [i32; 6000] = [0; 6000];

    let mut k = 0;
    let mut l = 0;
    loop {
        for j in 0..total_instructions {
            dup_program[j] = program[j];
        }

        println!("{} {}", k, l);
        let mut i : usize = 0;
        dup_program[1] = k;
        dup_program[2] = l;
        while i < total_instructions && dup_program[i] != 99 {
            match dup_program[i] {
                1 => {
                    let first_number = dup_program[ dup_program[i+1] as usize ];
                    let second_number = dup_program[ dup_program[i+2] as usize ];
                    dup_program[  dup_program[i+3] as usize ] = first_number + second_number;
                }
                2 => {
                    let first_number = dup_program[ dup_program[i+1] as usize ];
                    let second_number = dup_program[ dup_program[i+2] as usize ];
                    dup_program[  dup_program[i+3] as usize ] = first_number * second_number;
                }
                _ => { println!("NOT REGISTERED OP!! {}", dup_program[i]); }
            }

            i += 4;
        }

        if dup_program[0] == 19690720 {
            break
        }
        k += 1;
        if k > 99 {
            k = 0;
            l += 1;
        }
        if l > 99 {
            break;
        }
    }

    println!("{}", dup_program[0]);
}
