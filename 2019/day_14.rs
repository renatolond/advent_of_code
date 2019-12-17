use std::process;
use std::io;
use std::io::prelude::*;
use std::convert::TryInto;

struct Material {
    name: String,
    quantity: i32
}

struct Equation {
    left_side: Vec<Material>,
    right_side: Vec<Material>,
}

fn main() {
    let mut equations : Vec<Equation> = Vec::new();
    let mut fuel_equation;
    let mut ore_equations = Vec::new();
    for line in io::stdin().lock().lines() {
        let line_str: String = line.unwrap();
        let parts : Vec<&str> = line_str.split(" => ").collect();
        assert_eq!(parts.len(), 2);
        let mut left : Vec<Material> = Vec::new();
        let mut is_ore_equation = false;
        for material in parts[0].split(", ") {
            let mat_parts : Vec<&str> = material.split_whitespace().collect();
            assert_eq!(mat_parts.len(), 2);
            let qty : i32 = mat_parts[0].parse::<i32>().unwrap();
            let name  = mat_parts[1].to_string();
            if name == "ORE" {
                is_ore_equation = true;
            }
            left.push(Material { name: name, quantity: qty });
        }
        let mut right : Vec<Material> = Vec::new();
        let mut is_fuel_equation = false;
        for material in parts[1].split(", ") {
            let mat_parts : Vec<&str> = material.split_whitespace().collect();
            assert_eq!(mat_parts.len(), 2);
            let qty : i32 = mat_parts[0].parse::<i32>().unwrap();
            let name  = mat_parts[1].to_string();
            if name == "FUEL" {
                is_fuel_equation = true;
            }
            right.push(Material { name: name, quantity: qty });
        }
        if is_ore_equation {
            ore_equations.push(equations.len());
        }
        if is_fuel_equation {
            fuel_equation = equations.len();
        }

        equations.push(Equation { left_side: left, right_side: right });
    }
}
