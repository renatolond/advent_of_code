use std::process;
use std::io;
use std::io::prelude::*;
use std::convert::TryInto;

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

const MAX_PROGRAM: usize = 1045;
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

const WALL : i64 = 0;
const MOVED : i64 = 1;
const FOUND_SYSTEM : i64 = 2;

const MAX_SIZE : usize = 50;
static mut MAZE : [[char; MAX_SIZE]; MAX_SIZE] = [[' '; MAX_SIZE]; MAX_SIZE];

unsafe fn print_maze(pos_x : usize, pos_y : usize) {
    print!("\x1B[2J");
    print!("\x1B[0;0H");
    for i in 0..MAX_SIZE {
        for j in 0..MAX_SIZE {
            if pos_y == i && pos_x == j {
                print!("D");
            } else {
                print!("{}",MAZE[j][i]);
            }
        }
        println!("");
    }
}

unsafe fn real_main() {
    let mut instruction_pointer : Option<usize> = None;
    let mut pos_pointer : Option<usize> = None;
    let mut input;
    let total_instructions = MAX_PROGRAM;
    let stdin = io::stdin();
    let mut lines_iter = stdin.lock().lines();
    let mut pos_x : i32;
    let mut pos_y : i32;
    pos_x = (MAX_SIZE / 2) as i32;
    pos_y = (MAX_SIZE / 2) as i32;
    MAZE[pos_x as usize][pos_y as usize] = 'S';
    print_maze(pos_x.try_into().unwrap(), pos_y.try_into().unwrap());
    loop {
        {
            let mut result;
            loop {
                result = lines_iter.next().unwrap().unwrap().parse::<char>();
                match result {
                    Err(_) => { continue },
                    Ok('w') => { input = Some(2); break },
                    Ok('s') => { input = Some(1); break },
                    Ok('a') => { input = Some(3); break },
                    Ok('d') => { input = Some(4); break },
                    Ok(_) => { continue }
                }
            }
        }
        let dir_x : i32;
        let dir_y : i32;
        match input {
            Some(1) => { dir_x = 0; dir_y = 1; } // NORTH
            Some(2) => { dir_x = 0; dir_y = -1; } // SOUTH
            Some(3) => { dir_x = -1; dir_y = 0; } // WEST
            Some(4) => { dir_x = 1; dir_y = 0; } // EAST
            _ => { println!("Weird input!!"); process::exit(2) }
        }
        let (response, ptr, pos_ptr) = machine(input, instruction_pointer, total_instructions, pos_pointer);
        if ptr == None {
            println!("Machine out!");
            break;
        }
        instruction_pointer = ptr;
        pos_pointer = pos_ptr;
        match response.unwrap() {
            WALL => { MAZE[(pos_x + dir_x) as usize][(pos_y + dir_y) as usize] = '#' }
            MOVED => { MAZE[(pos_x + dir_x) as usize][(pos_y + dir_y) as usize] = '.'; pos_x += dir_x; pos_y += dir_y; }
            FOUND_SYSTEM => { MAZE[(pos_x + dir_x) as usize][(pos_y + dir_y) as usize] = 'O'; pos_x += dir_x; pos_y += dir_y; }
            _ => { println!("unknown id"); process::exit(1) }
        }

        print_maze(pos_x.try_into().unwrap(), pos_y.try_into().unwrap());
    }
}

fn main() {
    unsafe { real_main() }
}
