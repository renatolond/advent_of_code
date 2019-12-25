use std::io;
use std::io::prelude::*;

const MAX_SIZE : usize = 41 + 2;
static mut MAZE : [[char; MAX_SIZE]; MAX_SIZE] = [[' '; MAX_SIZE]; MAX_SIZE];
unsafe fn print_maze() {
    print!("\x1B[2J");
    print!("\x1B[0;0H");
    for i in 0..MAX_SIZE {
        for j in 0..MAX_SIZE {
            print!("{}",MAZE[i][j]);
        }
        println!("");
    }
}

unsafe fn real_main() {
    let stdin = io::stdin();
    let mut lines_iter = stdin.lock().lines();
    let mut minutes = 0;
    loop {
        for i in 1..MAX_SIZE-1 {
            for j in 1..MAX_SIZE-1 {
                if MAZE[i][j] == 'O' {
                    if MAZE[i-1][j] == '.' {
                        MAZE[i-1][j] = 'N';
                    }
                    if MAZE[i+1][j] == '.' {
                        MAZE[i+1][j] = 'N';
                    }
                    if MAZE[i][j-1] == '.' {
                        MAZE[i][j-1] = 'N';
                    }
                    if MAZE[i][j+1] == '.' {
                        MAZE[i][j+1] = 'N';
                    }
                }
            }
        }
        print_maze();
        let mut no_more = true;
        for i in 1..MAX_SIZE-1 {
            for j in 1..MAX_SIZE-1 {
                if MAZE[i][j] == 'N' {
                    MAZE[i][j] = 'O';
                    no_more = false;
                }
            }
        }
        if no_more {
            break;
        }
        minutes += 1;
        lines_iter.next();
    }
    println!("{}", minutes);
}

fn main() {
    unsafe { real_main(); }
}
