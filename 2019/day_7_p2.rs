use std::process;
use std::io;
use std::io::prelude::*;

const MAX_PROGRAM: usize = 6000;

static mut programs : [[i32; MAX_PROGRAM]; 5] = [[0; MAX_PROGRAM]; 5];
unsafe fn machine(instruction_pointer: Option<usize>, mut input: Option<i32>, prg_idx: usize, total_instructions: usize) -> (Option<i32>,Option<usize>) {
    let mut output: Option<i32> = None;
    let mut i : usize;

    match instruction_pointer {
        None => { i = 0; },
        Some(x) => { i = x; }
    }

    //println!("starting machine {} with input {:?}, ptr at {}", prg_idx, input, i);

    while i < total_instructions && programs[prg_idx][i] != 99 {
        let instruction = programs[prg_idx][i] % 100;
        let modes = ((programs[prg_idx][i] / 100) % 10, (programs[prg_idx][i] / 1_000) % 10, (programs[prg_idx][i] / 10_000) % 10);
        //println!("({}) {} {:?}", prg_idx, instruction, modes);
        match instruction {
            1 => { // Sum OP
                let mut first_number = programs[prg_idx][i+1];
                if modes.0 == 0 {
                    first_number = programs[prg_idx][ first_number as usize ];
                }

                let mut second_number = programs[prg_idx][i+2];
                if modes.1 == 0 {
                    second_number = programs[prg_idx][ programs[prg_idx][i+2] as usize ];
                }
                programs[prg_idx][  programs[prg_idx][i+3] as usize ] = first_number + second_number;
                i += 4;
            }
            2 => { // Multiplication OP
                let mut first_number = programs[prg_idx][i+1];
                if modes.0 == 0 {
                    first_number = programs[prg_idx][ first_number as usize ];
                }

                let mut second_number = programs[prg_idx][i+2];
                if modes.1 == 0 {
                    second_number = programs[prg_idx][ programs[prg_idx][i+2] as usize ];
                }
                programs[prg_idx][  programs[prg_idx][i+3] as usize ] = first_number * second_number;
                i += 4;
            }
            3 => { // Input OP
                let input_number;
                if input == None {
                    return (None, Some(i));
                } else {
                    input_number = input.unwrap();
                    input = None;
                }

                if modes.0 == 0 {
                    programs[prg_idx][ programs[prg_idx][i+1] as usize ] = input_number;
                } else {
                    programs[prg_idx][i+1] = input_number;
                }
                i += 2;
            }
            4 => { // Output OP
                if modes.0 == 0 {
                    output = Some(programs[prg_idx][ programs[prg_idx][i+1] as usize ]);
                } else {
                    output = Some(programs[prg_idx][i+1]);
                }
                i += 2;
                //println!("{:?} {:?}", output, Some(i));
                return (output, Some(i));
            }
            5 => { // Jump-if-true
                let mut first_number = programs[prg_idx][i+1];
                if modes.0 == 0 {
                    first_number = programs[prg_idx][ first_number as usize ];
                }

                let mut second_number = programs[prg_idx][i+2];
                if modes.1 == 0 {
                    second_number = programs[prg_idx][ programs[prg_idx][i+2] as usize ];
                }

                if first_number != 0 {
                    i = second_number as usize
                } else {
                    i += 3;
                }
            }
            6 => { // Jump-if-false
                let mut first_number = programs[prg_idx][i+1];
                if modes.0 == 0 {
                    first_number = programs[prg_idx][ first_number as usize ];
                }

                let mut second_number = programs[prg_idx][i+2];
                if modes.1 == 0 {
                    second_number = programs[prg_idx][ programs[prg_idx][i+2] as usize ];
                }

                if first_number == 0 {
                    i = second_number as usize
                } else {
                    i += 3;
                }
            }
            7 => { // less than OP
                let mut first_number = programs[prg_idx][i+1];
                if modes.0 == 0 {
                    first_number = programs[prg_idx][ first_number as usize ];
                }

                let mut second_number = programs[prg_idx][i+2];
                if modes.1 == 0 {
                    second_number = programs[prg_idx][ programs[prg_idx][i+2] as usize ];
                }
                if first_number < second_number {
                    programs[prg_idx][  programs[prg_idx][i+3] as usize ] = 1;
                } else {
                    programs[prg_idx][  programs[prg_idx][i+3] as usize ] = 0;
                }
                i += 4;
            }
            8 => { // less than OP
                let mut first_number = programs[prg_idx][i+1];
                if modes.0 == 0 {
                    first_number = programs[prg_idx][ first_number as usize ];
                }

                let mut second_number = programs[prg_idx][i+2];
                if modes.1 == 0 {
                    second_number = programs[prg_idx][ programs[prg_idx][i+2] as usize ];
                }
                if first_number == second_number {
                    programs[prg_idx][  programs[prg_idx][i+3] as usize ] = 1;
                } else {
                    programs[prg_idx][  programs[prg_idx][i+3] as usize ] = 0;
                }
                i += 4;
            }
            _ => { println!("NOT REGISTERED OP!! {}", programs[prg_idx][i]); process::exit(1)}
        }
    }
    return (output, Some(MAX_PROGRAM+1));
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

    let perms : [[i32; 5]; 120] = [[5, 6, 7, 8, 9], [5, 6, 7, 9, 8], [5, 6, 8, 7, 9], [5, 6, 8, 9, 7], [5, 6, 9, 7, 8], [5, 6, 9, 8, 7], [5, 7, 6, 8, 9], [5, 7, 6, 9, 8], [5, 7, 8, 6, 9], [5, 7, 8, 9, 6], [5, 7, 9, 6, 8], [5, 7, 9, 8, 6], [5, 8, 6, 7, 9], [5, 8, 6, 9, 7], [5, 8, 7, 6, 9], [5, 8, 7, 9, 6], [5, 8, 9, 6, 7], [5, 8, 9, 7, 6], [5, 9, 6, 7, 8], [5, 9, 6, 8, 7], [5, 9, 7, 6, 8], [5, 9, 7, 8, 6], [5, 9, 8, 6, 7], [5, 9, 8, 7, 6], [6, 5, 7, 8, 9], [6, 5, 7, 9, 8], [6, 5, 8, 7, 9], [6, 5, 8, 9, 7], [6, 5, 9, 7, 8], [6, 5, 9, 8, 7], [6, 7, 5, 8, 9], [6, 7, 5, 9, 8], [6, 7, 8, 5, 9], [6, 7, 8, 9, 5], [6, 7, 9, 5, 8], [6, 7, 9, 8, 5], [6, 8, 5, 7, 9], [6, 8, 5, 9, 7], [6, 8, 7, 5, 9], [6, 8, 7, 9, 5], [6, 8, 9, 5, 7], [6, 8, 9, 7, 5], [6, 9, 5, 7, 8], [6, 9, 5, 8, 7], [6, 9, 7, 5, 8], [6, 9, 7, 8, 5], [6, 9, 8, 5, 7], [6, 9, 8, 7, 5], [7, 5, 6, 8, 9], [7, 5, 6, 9, 8], [7, 5, 8, 6, 9], [7, 5, 8, 9, 6], [7, 5, 9, 6, 8], [7, 5, 9, 8, 6], [7, 6, 5, 8, 9], [7, 6, 5, 9, 8], [7, 6, 8, 5, 9], [7, 6, 8, 9, 5], [7, 6, 9, 5, 8], [7, 6, 9, 8, 5], [7, 8, 5, 6, 9], [7, 8, 5, 9, 6], [7, 8, 6, 5, 9], [7, 8, 6, 9, 5], [7, 8, 9, 5, 6], [7, 8, 9, 6, 5], [7, 9, 5, 6, 8], [7, 9, 5, 8, 6], [7, 9, 6, 5, 8], [7, 9, 6, 8, 5], [7, 9, 8, 5, 6], [7, 9, 8, 6, 5], [8, 5, 6, 7, 9], [8, 5, 6, 9, 7], [8, 5, 7, 6, 9], [8, 5, 7, 9, 6], [8, 5, 9, 6, 7], [8, 5, 9, 7, 6], [8, 6, 5, 7, 9], [8, 6, 5, 9, 7], [8, 6, 7, 5, 9], [8, 6, 7, 9, 5], [8, 6, 9, 5, 7], [8, 6, 9, 7, 5], [8, 7, 5, 6, 9], [8, 7, 5, 9, 6], [8, 7, 6, 5, 9], [8, 7, 6, 9, 5], [8, 7, 9, 5, 6], [8, 7, 9, 6, 5], [8, 9, 5, 6, 7], [8, 9, 5, 7, 6], [8, 9, 6, 5, 7], [8, 9, 6, 7, 5], [8, 9, 7, 5, 6], [8, 9, 7, 6, 5], [9, 5, 6, 7, 8], [9, 5, 6, 8, 7], [9, 5, 7, 6, 8], [9, 5, 7, 8, 6], [9, 5, 8, 6, 7], [9, 5, 8, 7, 6], [9, 6, 5, 7, 8], [9, 6, 5, 8, 7], [9, 6, 7, 5, 8], [9, 6, 7, 8, 5], [9, 6, 8, 5, 7], [9, 6, 8, 7, 5], [9, 7, 5, 6, 8], [9, 7, 5, 8, 6], [9, 7, 6, 5, 8], [9, 7, 6, 8, 5], [9, 7, 8, 5, 6], [9, 7, 8, 6, 5], [9, 8, 5, 6, 7], [9, 8, 5, 7, 6], [9, 8, 6, 5, 7], [9, 8, 6, 7, 5], [9, 8, 7, 5, 6], [9, 8, 7, 6, 5]];

    let mut max_signal = -9999999;
    let mut pointers : [Option<usize>; 5] = [None; 5];
    let mut finished : bool = false;

    for perm in perms.iter() 
    {
        unsafe {
            for i in 0..5 {
                for j in 0..total_instructions {
                    programs[i][j] = program[j] as i32;
                }
                pointers[i] = None;
                finished = false;
            }
        }
        let mut signal = 0;
        let mut first_iter = true;
        loop {
            for j in 0..5 {
                let phase = perm[j];
                let mut out = None;
                let mut ptr = pointers[j];
                if first_iter {
                    unsafe {
                        let ret1 = machine(ptr, Some(phase), j, total_instructions) ;
                        out = ret1.0;
                        ptr = ret1.1;
                    }
                }
                if out == None {
                    unsafe {
                        let ret = machine(ptr, Some(signal), j, total_instructions);
                        out = ret.0;
                        ptr = ret.1;
                    }
                }
                pointers[j] = ptr;
                match out {
                    None => { finished = true; break; }
                    Some(x) => {
                        signal = x;
                    }
                }
            }
            first_iter = false;
            //println!("{}", signal);
            if finished {
                break
            }
        }
        if signal > max_signal {
            max_signal = signal
        }
    }
    println!("{}", max_signal);
}
