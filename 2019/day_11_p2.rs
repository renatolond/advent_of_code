use std::process;
use std::io;
use std::io::prelude::*;
use std::convert::TryInto;
use std::f64;

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

const MAX_PROGRAM: usize = 5000;
static mut PROGRAM : [i64; MAX_PROGRAM] = [0; MAX_PROGRAM];
unsafe fn machine(mut input: Option<i64>, instruction_pointer : Option<usize>, total_instructions: usize, pos_pointer: Option<usize>) -> (Option<i64>,Option<usize>,Option<usize>) {
    let mut i : usize;
    let mut pos_mode_ptr;

    match instruction_pointer {
        None => { i = 0; },
        Some(x) => { i = x; }
    }

    match pos_pointer {
        None => { pos_mode_ptr = 0; },
        Some(x) => { pos_mode_ptr = x; }
    }

    //println!("starting machine {} with input {:?}, ptr at {}", prg_idx, input, i);

    while i < total_instructions && PROGRAM[i] != 99 {
        let instruction = PROGRAM[i] % 100;
        let modes = ((PROGRAM[i] / 100) % 10, (PROGRAM[i] / 1_000) % 10, (PROGRAM[i] / 10_000) % 10);
        //println!("({}) {} {:?}", prg_idx, instruction, modes);
        match instruction {
            1 => { // Sum OP
                let first_number;
                machine_param!(modes.0, PROGRAM, first_number, pos_mode_ptr, i+1);

                let second_number;
                machine_param!(modes.1, PROGRAM, second_number, pos_mode_ptr, i+2);

                let result = first_number + second_number;
                result_expr!(modes.2, PROGRAM, result, pos_mode_ptr, i+3);
                i += 4;
            }
            2 => { // Multiplication OP
                let first_number;
                machine_param!(modes.0, PROGRAM, first_number, pos_mode_ptr, i+1);

                let second_number;
                machine_param!(modes.1, PROGRAM, second_number, pos_mode_ptr, i+2);

                let result = first_number * second_number;
                result_expr!(modes.2, PROGRAM, result, pos_mode_ptr, i+3);
                i += 4;
            }
            3 => { // Input OP
                let input_number;
                if input == None {
                    return (None, Some(i), Some(pos_mode_ptr));
                } else {
                    input_number = input.unwrap();
                    input = None;
                }

                if modes.0 == 0 {
                    PROGRAM[ PROGRAM[i+1] as usize ] = input_number;
                } else if modes.0 == 2 {
                    PROGRAM[ (pos_mode_ptr as i64 + PROGRAM[i+1] ) as usize ] = input_number;
                } else {
                    PROGRAM[i+1] = input_number;
                }
                i += 2;
            }
            4 => { // Output OP
                let output;
                machine_param!(modes.0, PROGRAM, output, pos_mode_ptr, i+1);
                i += 2;
                //println!("{:?}", output);
                return (Some(output), Some(i), Some(pos_mode_ptr));
            }
            5 => { // Jump-if-true
                let first_number;
                machine_param!(modes.0, PROGRAM, first_number, pos_mode_ptr, i+1);

                let second_number;
                machine_param!(modes.1, PROGRAM, second_number, pos_mode_ptr, i+2);

                if first_number != 0 {
                    i = second_number as usize
                } else {
                    i += 3;
                }
            }
            6 => { // Jump-if-false
                let first_number;
                machine_param!(modes.0, PROGRAM, first_number, pos_mode_ptr, i+1);

                let second_number;
                machine_param!(modes.1, PROGRAM, second_number, pos_mode_ptr, i+2);

                if first_number == 0 {
                    i = second_number as usize
                } else {
                    i += 3;
                }
            }
            7 => { // less than OP
                let first_number;
                machine_param!(modes.0, PROGRAM, first_number, pos_mode_ptr, i+1);

                let second_number;
                machine_param!(modes.1, PROGRAM, second_number, pos_mode_ptr, i+2);

                if first_number < second_number {
                    result_expr!(modes.2, PROGRAM, 1, pos_mode_ptr, i+3);
                } else {
                    result_expr!(modes.2, PROGRAM, 0, pos_mode_ptr, i+3);
                }
                i += 4;
            }
            8 => { // less than OP
                let first_number;
                machine_param!(modes.0, PROGRAM, first_number, pos_mode_ptr, i+1);

                let second_number;
                machine_param!(modes.1, PROGRAM, second_number, pos_mode_ptr, i+2);

                if first_number == second_number {
                    result_expr!(modes.2, PROGRAM, 1, pos_mode_ptr, i+3);
                } else {
                    result_expr!(modes.2, PROGRAM, 0, pos_mode_ptr, i+3);
                }
                i += 4;
            }
            9 => { // relative offset base adjust
                let first_number;
                machine_param!(modes.0, PROGRAM, first_number, pos_mode_ptr, i+1);

                pos_mode_ptr = ((pos_mode_ptr as i64) + first_number) as usize;

                i += 2;
            }
            _ => { println!("NOT REGISTERED OP!! {}", PROGRAM[i]); process::exit(1)}
        }
    }
    return (None, None,None);
}

fn trigo_transform(angle : f64) -> (i64, i64) {
    let y = angle.sin().round() as i64;
    let x = angle.cos().round() as i64;
    return (y, x);
}

const MOVE_LEFT : i64 = 0;
const MOVE_RIGHT : i64 = 1;
const HULL_DIMENSIONS : usize = 100;
static mut hull : [[bool; HULL_DIMENSIONS]; HULL_DIMENSIONS] = [[false; HULL_DIMENSIONS]; HULL_DIMENSIONS];
static mut painted : [[bool; HULL_DIMENSIONS]; HULL_DIMENSIONS] = [[false; HULL_DIMENSIONS]; HULL_DIMENSIONS];
unsafe fn real_main() {
    let mut total_instructions = 0;
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let mut i = 0;
        for number in line_str.split(',') {
            PROGRAM[i] = number.parse::<i64>().unwrap();
            i = i+1;
        }
        total_instructions = i;
    }

    let mut robot_pos = (HULL_DIMENSIONS / 2, HULL_DIMENSIONS / 2);
    hull[robot_pos.0][robot_pos.1] = true;
    let mut facing = std::f64::consts::PI/2.0; // Up!
    let mut robot_mov;
    let mut instruction_pointer : Option<usize> = None;
    let mut pos_pointer : Option<usize> = None;
    loop {
        // Get color to paint
        let color_ret = machine(Some(hull[robot_pos.0][robot_pos.1].try_into().unwrap()), instruction_pointer, total_instructions, pos_pointer);
        instruction_pointer = color_ret.1;
        pos_pointer = color_ret.2;
        let hull_color = color_ret.0;

        if instruction_pointer == None {
            break
        }
        hull[robot_pos.0][robot_pos.1] = hull_color.unwrap() == 1;
        painted[robot_pos.0][robot_pos.1] = true;

        let move_ret = machine(Some(hull[robot_pos.0][robot_pos.1].try_into().unwrap()), instruction_pointer, total_instructions, pos_pointer);
        instruction_pointer = move_ret.1;
        pos_pointer = move_ret.2;
        if instruction_pointer == None {
            break
        }
        match move_ret.0.unwrap() {
            MOVE_LEFT => {
                println!("Painted {}, turned left and moved", hull_color.unwrap());
                facing += std::f64::consts::PI/2.0;
                if facing >= 2.0*std::f64::consts::PI {
                    facing -= 2.0*std::f64::consts::PI;
                }
            } // move_left
            MOVE_RIGHT => {
                println!("Painted {}, turned right and moved", hull_color.unwrap());
                facing -= std::f64::consts::PI/2.0;
                if facing <= 0.0 {
                    facing += 2.0*std::f64::consts::PI;
                }
            }
            _ => { println!("ERROR: not the expected turn"); process::exit(1); }
        }
        robot_mov = trigo_transform(facing);
        robot_pos.0 = (robot_pos.0 as i64 + robot_mov.0).try_into().unwrap();
        robot_pos.1 = (robot_pos.1 as i64 + robot_mov.1).try_into().unwrap();
    }

    let mut panels = 0;
    let mut i : i32 = HULL_DIMENSIONS as i32 - 1;
    loop {
        let mut j : i32 = 0;
        loop {
            if hull[i as usize][j as usize] == true {
                print!("#");
            } else {
                print!(".");
            }
            j += 1;
            if j >= HULL_DIMENSIONS as i32 {
                break
            }
        }
        println!("");
        i -= 1;
        if i < 0 {
            break
        }
    }

    println!("{}",panels);
}

fn main() {
    unsafe { real_main(); }
}
