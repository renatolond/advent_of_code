use std::io;
use std::io::prelude::*;

fn main() {
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let beginning_and_end : Vec<&str> = line_str.split("-").collect();
        let beginning : i32 = beginning_and_end[0].parse().unwrap();
        let end : i32 = beginning_and_end[1].parse().unwrap();

        let mut possible_passwords = 0;
        for i in beginning as usize..(end+1) as usize{
            let password_chars : Vec<char>= i.to_string().chars().collect();

            let mut has_double = false;
            let mut decreasing_chars = false;
            let mut j = 0;
            loop {
                if password_chars[j] == password_chars[j+1] {
                    let mut local_double = true;
                    while j + 2 < password_chars.len() {
                        if password_chars[j+1] == password_chars[j+2] {
                            local_double = false;
                            j += 1;
                        } else {
                            break;
                        }
                    }
                    has_double = has_double | local_double;
                }
                if password_chars[j] > password_chars[j+1] {
                    decreasing_chars = true;
                }
                j+=1;
                if j >= password_chars.len() - 1 {
                    break
                }
            }
            if has_double && !decreasing_chars {
                possible_passwords += 1;
            }
        }

        println!("{}", possible_passwords);
    }
}

