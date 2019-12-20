use std::process;
use std::io;
use std::io::prelude::*;
use std::convert::TryInto;
use std::collections::HashSet;

#[derive(Debug)]
struct Material {
    name: String,
    quantity: i32
}

impl PartialEq for Material {
    fn eq(&self, other: &Self) -> bool {
        self.name == other.name
    }
}

struct Equation {
    left_side: Vec<Material>,
    right_side: Vec<Material>,
}

fn main() {
    let mut equations : Vec<Equation> = Vec::new();
    let mut fuel_equation_idx = 9999999;
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
            fuel_equation_idx = equations.len();
        }

        equations.push(Equation { left_side: left, right_side: right });
    }

    let mut base_materials = HashSet::new();

    for equation_idx in ore_equations.iter() {
        assert_eq!(equations[*equation_idx].right_side.len(), 1);
        base_materials.insert(equations[*equation_idx].right_side[0].name.clone());
    }

    // Step 1: Convert all non-ORE elements into ORE elements
    let mut element_idx = 0;
    loop {
        if element_idx > equations[fuel_equation_idx].left_side.len() {
            break;
        }

        if equations[fuel_equation_idx].left_side[element_idx].name == "ORE" {
            element_idx += 1;
        }

        if equations[fuel_equation_idx].left_side.len() == ore_equations.len() {
            println!("Same elements as the ore equations, lets see if we're good");
            // we have to then check if all the right side is only the ore outputs
            let mut reduced_equation = true;
            for element in equations[fuel_equation_idx].left_side.iter() {
                if !base_materials.contains(&element.name) {
                    reduced_equation = false;
                    break;
                }
            }
            if reduced_equation {
                println!("Seems like it's well reduced, let's get out");
                break;
            }
        }

        let mut next_idx = None;
        for equation_idx in 0..equations.len() {
            if equation_idx == fuel_equation_idx || ore_equations.contains(&equation_idx) {
                continue;
            }
            if equations[fuel_equation_idx].left_side[element_idx].name == equations[equation_idx].right_side[0].name {
                next_idx = Some(equation_idx);
                break;
            }
        }

        if next_idx == None { // This is an ore element, skip it
            println!("Ore element, skipping it!");
            element_idx += 1;
            continue;
        }


        {
            let equation_idx = next_idx.unwrap();
            let mut material : Material;
            let mut fuel_equation = equations.remove(fuel_equation_idx);
            material = fuel_equation.left_side.remove(element_idx);
            println!("Chose {}", material.name);
            assert_eq!(material.quantity % equations[equation_idx].right_side[0].quantity, 0);
            for element in equations[equation_idx].left_side.iter() {
                if fuel_equation.left_side.contains(&element) {
                    for el in fuel_equation.left_side.iter_mut() {
                        if el.name == element.name {
                            el.quantity += element.quantity;
                            break;
                        }
                    }
                } else {
                    fuel_equation.left_side.push( Material { name: element.name.clone(), quantity: element.quantity } );
                }
            }

            for element in fuel_equation.left_side.iter() {
                println!("{:?}", element);
            }
            fuel_equation_idx = equations.len();
            equations.push(fuel_equation);
        }
    }

    println!("Fuel equation seems reduced. Let's move forward");
}
