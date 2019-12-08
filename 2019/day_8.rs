//use std::process;
use std::io;
use std::io::prelude::*;
use std::convert::TryInto;

fn main() {
    let mut image : Vec<Vec<Vec<i8>>> = Vec::new();
    let wideness = 25;
    let tallness = 6;
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
                if col >= wideness {
                    col = 0;
                    row += 1;
                    if row >= tallness {
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

    let mut checksums = vec![0; image.len()];
    let mut min_layer : (i32, usize) = (99999999, image.len()+1);
    let mut i = 0;
    for layer in &image {
        let mut count_zeros = 0;
        let mut count_one = 0;
        let mut count_two = 0;
        for line in layer {
            for row in line {
                match row {
                    0 => { count_zeros += 1 }
                    1 => { count_one += 1 }
                    2 => { count_two += 1 }
                    _ => {}
                }
            }
        }
        if count_zeros < min_layer.0 {
            min_layer = (count_zeros, i);
        }
        checksums[i] = count_one*count_two;
        i += 1;
    }
    println!("{:?}", checksums[min_layer.1]);
}
