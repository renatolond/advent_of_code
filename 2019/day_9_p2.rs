use std::process;
use std::io;
use std::io::prelude::*;

macro_rules! machine_param {
    ( $mode_var:expr, $program_var:expr, $dest_var:expr, $pos_mode_var:expr, $idx:expr ) => {
        match $mode_var {
            0 => { let value = $program_var[$idx]; $dest_var = $program_var[value as usize] }
            1 => { let value = $program_var[$idx]; $dest_var = value }
            2 => { let value = $program_var[$idx]; $dest_var = $program_var[($pos_mode_var as i64 + value) as usize] }
            _ => { println!("Panic! Unknown mode {}!", $mode_var); process::exit(1) }
        }
    }
}

macro_rules! result_expr {
    ( $mode_var:expr, $program_var:expr, $result_var:expr, $pos_mode_var:expr, $idx:expr ) => {
        match $mode_var {
            0 => { let value = $program_var[$idx]; $program_var[value as usize] = $result_var }
            1 => { println!("Panic! Cannot use mode {} for assignment!", $mode_var); process::exit(1) }
            2 => { let value = $program_var[$idx]; $program_var[($pos_mode_var as i64 + value) as usize] = $result_var }
            _ => { println!("Panic! Unknown mode {}!", $mode_var); process::exit(1) }
        }
    }
}

const MAX_PROGRAM: usize = 10000;
unsafe fn machine(mut input: Option<i64>, _program: [i64; MAX_PROGRAM], total_instructions: usize) -> (Option<i64>,Option<usize>) {
    let mut output: Option<i64> = None;
    let mut i : usize = 0;
    let mut pos_mode_ptr = 0;

    let mut program : [i64; MAX_PROGRAM] = [0; MAX_PROGRAM];
    for i in 0..total_instructions {
        program[i] = _program[i];
    }

    //match instruction_pointer {
    //    None => { i = 0; },
    //    Some(x) => { i = x; }
    //}

    //println!("starting machine {} with input {:?}, ptr at {}", prg_idx, input, i);

    while i < total_instructions && program[i] != 99 {
        let instruction = program[i] % 100;
        let modes = ((program[i] / 100) % 10, (program[i] / 1_000) % 10, (program[i] / 10_000) % 10);
        //println!("({}) {} {:?}", prg_idx, instruction, modes);
        match instruction {
            1 => { // Sum OP
                let first_number;
                machine_param!(modes.0, program, first_number, pos_mode_ptr, i+1);

                let second_number;
                machine_param!(modes.1, program, second_number, pos_mode_ptr, i+2);

                let result = first_number + second_number;
                result_expr!(modes.2, program, result, pos_mode_ptr, i+3);
                i += 4;
            }
            2 => { // Multiplication OP
                let first_number;
                machine_param!(modes.0, program, first_number, pos_mode_ptr, i+1);

                let second_number;
                machine_param!(modes.1, program, second_number, pos_mode_ptr, i+2);

                let result = first_number * second_number;
                result_expr!(modes.2, program, result, pos_mode_ptr, i+3);
                i += 4;
            }
            3 => { // Input OP
                let input_number = input.unwrap();
                //if input == None {
                //    return (None, Some(i));
                //} else {
                //    input_number = input.unwrap();
                //    input = None;
                //}

                if modes.0 == 0 {
                    program[ program[i+1] as usize ] = input_number;
                } else if modes.0 == 2 {
                    program[ (pos_mode_ptr as i64 + program[i+1] ) as usize ] = input_number;
                } else {
                    program[i+1] = input_number;
                }
                i += 2;
            }
            4 => { // Output OP
                let output;
                machine_param!(modes.0, program, output, pos_mode_ptr, i+1);
                i += 2;
                println!("{:?}", output);
                //return (output, Some(i));
            }
            5 => { // Jump-if-true
                let first_number;
                machine_param!(modes.0, program, first_number, pos_mode_ptr, i+1);

                let second_number;
                machine_param!(modes.1, program, second_number, pos_mode_ptr, i+2);

                if first_number != 0 {
                    i = second_number as usize
                } else {
                    i += 3;
                }
            }
            6 => { // Jump-if-false
                let first_number;
                machine_param!(modes.0, program, first_number, pos_mode_ptr, i+1);

                let second_number;
                machine_param!(modes.1, program, second_number, pos_mode_ptr, i+2);

                if first_number == 0 {
                    i = second_number as usize
                } else {
                    i += 3;
                }
            }
            7 => { // less than OP
                let first_number;
                machine_param!(modes.0, program, first_number, pos_mode_ptr, i+1);

                let second_number;
                machine_param!(modes.1, program, second_number, pos_mode_ptr, i+2);

                if first_number < second_number {
                    result_expr!(modes.2, program, 1, pos_mode_ptr, i+3);
                } else {
                    result_expr!(modes.2, program, 0, pos_mode_ptr, i+3);
                }
                i += 4;
            }
            8 => { // less than OP
                let first_number;
                machine_param!(modes.0, program, first_number, pos_mode_ptr, i+1);

                let second_number;
                machine_param!(modes.1, program, second_number, pos_mode_ptr, i+2);

                if first_number == second_number {
                    result_expr!(modes.2, program, 1, pos_mode_ptr, i+3);
                } else {
                    result_expr!(modes.2, program, 0, pos_mode_ptr, i+3);
                }
                i += 4;
            }
            9 => { // relative offset base adjust
                let first_number;
                machine_param!(modes.0, program, first_number, pos_mode_ptr, i+1);

                pos_mode_ptr = ((pos_mode_ptr as i64) + first_number) as usize;

                i += 2;
            }
            _ => { println!("NOT REGISTERED OP!! {}", program[i]); process::exit(1)}
        }
    }
    return (output, Some(MAX_PROGRAM+1));
}

fn main() {
    let mut program : [i64; MAX_PROGRAM] = [0; MAX_PROGRAM];
    let mut total_instructions = 0;
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let mut i = 0;
        for number in line_str.split(',') {
            program[i] = number.parse::<i64>().unwrap();
            i = i+1;
        }
        total_instructions = i;
    }

    unsafe { machine(Some(2), program, total_instructions); }
}
