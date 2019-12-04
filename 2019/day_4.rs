use std::io;
use std::io::prelude::*;

fn main() {
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let beginning_and_end : Vec<&str> = line_str.split("-").collect();
        let beginning : i32 = beginning_and_end[0].parse().unwrap();
        let end : i32 = beginning_and_end[1].parse().unwrap();

        let mut possible_passwords = 0;
        for i in beginning as usize..end as usize{
            let password_chars : Vec<char>= i.to_string().chars().collect();

            let mut has_double = false;
            let mut decreasing_chars = false;
            for j in 0..(password_chars.len() - 1) {
                if password_chars[j] == password_chars[j+1] {
                    has_double = true;
                }
                if password_chars[j] > password_chars[j+1] {
                    decreasing_chars = true;
                }
            }
            if has_double && !decreasing_chars {
                possible_passwords += 1
            }
        }

        println!("{}", possible_passwords);
    }
}
