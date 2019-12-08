//use std::process;
use std::io;
use std::io::prelude::*;
use std::convert::TryInto;

const BLACK_PIXEL : i8 = 0;
const WHITE_PIXEL : i8 = 1;
const TRANSPARENT_PIXEL : i8 = 2;

const WIDENESS : usize = 25;
const TALLNESS : usize = 6;
fn main() {
    let mut image : Vec<Vec<Vec<i8>>> = Vec::new();
    {
        let mut layer = 0;
        let mut row = 0;
        let mut col = 0;
        let mut i = 0;
        for line in io::stdin().lock().lines() {
            let line_str: String = line.unwrap();
            let strs : Vec<char>= line_str.chars().collect();
            loop {
                if row == 0 && col == 0 { // new layer
                    image.push(Vec::new()); // new layer
                }
                if col == 0 { // new line
                    image[layer].push(Vec::new()); // new line
                }
                image[layer][row].push(strs[i].to_digit(10).unwrap().try_into().unwrap());
                i += 1;
                col += 1;
                if col >= WIDENESS {
                    col = 0;
                    row += 1;
                    if row >= TALLNESS {
                        row = 0;
                        layer += 1;
                    }
                }
                if i >= strs.len() {
                    break;
                }
            }
        }
    }

    let mut final_image : [[char; WIDENESS]; TALLNESS] = [[' '; WIDENESS]; TALLNESS];

    for i in 0..TALLNESS {
        for j in 0..WIDENESS {
            let mut k = 0;
            loop {
                match image[k][i][j] {
                    BLACK_PIXEL => {
                        final_image[i][j] = '█';
                        break;
                    }
                    WHITE_PIXEL => {
                        final_image[i][j] = ' ';
                        break;
                    }
                    TRANSPARENT_PIXEL => {
                        k += 1;
                    }
                    _ => {}
                }
            }
        }
    }
    for i in 0..TALLNESS {
        for j in 0..WIDENESS {
            print!("{}", final_image[i][j]);
        }
        println!("");
    }
}
