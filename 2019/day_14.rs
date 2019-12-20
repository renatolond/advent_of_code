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

static mut EQUATIONS : Vec<Equation> = Vec::new();
static mut ORE_EQUATIONS : Vec<usize> = Vec::new();

static mut BASE_MATERIALS : Vec<String> = Vec::new();

static mut equation_queue : Vec<usize> = Vec::new();

unsafe fn reduce_equation(main_equation_idx : usize, ignore_ores : bool) {
    // Step 1: Convert all non-ORE elements into ORE elements
    let mut element_idx = 0;
    loop {
        println!("Looking at #{} : {:?}", element_idx, EQUATIONS[main_equation_idx].left_side[element_idx]);
        if element_idx >= EQUATIONS[main_equation_idx].left_side.len() {
            break;
        }

        if EQUATIONS[main_equation_idx].left_side[element_idx].name == "ORE" {
            println!("panic?");
            process::exit(2);
        }

        if EQUATIONS[main_equation_idx].left_side.len() == ORE_EQUATIONS.len() {
            println!("Same elements as the ore EQUATIONS, lets see if we're good");
            // we have to then check if all the right side is only the ore outputs
            let mut reduced_equation = true;
            for element in EQUATIONS[main_equation_idx].left_side.iter() {
                println!("{:?}", element);
                if !BASE_MATERIALS.contains(&element.name) {
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
        for equation_idx in 0..EQUATIONS.len() {
            if equation_idx == main_equation_idx || (ignore_ores && ORE_EQUATIONS.contains(&equation_idx)) {
                continue;
            }
            if EQUATIONS[main_equation_idx].left_side[element_idx].name == EQUATIONS[equation_idx].right_side[0].name {
                next_idx = Some(equation_idx);
                break;
            }
        }

        if next_idx == None { // This is an ore element, skip it
            println!("Ore element #{}, skipping it!", EQUATIONS[main_equation_idx].left_side[element_idx].name);
            element_idx += 1;
            continue;
        }


        {
            let equation_idx = next_idx.unwrap();
            let mut material : Material;
            let mut main_equation = &mut EQUATIONS[main_equation_idx];
            println!("#{}",element_idx);
            material = main_equation.left_side.remove(element_idx);
            let multiplier;
            if material.quantity % EQUATIONS[equation_idx].right_side[0].quantity != 0 {
                println!("Equation {} needs to be reduced!", equation_idx);
                equation_queue.push(equation_idx);
                continue;
            } else {
                multiplier = material.quantity / EQUATIONS[equation_idx].right_side[0].quantity;
            }
            println!("Chose {} * {}", material.name, multiplier);
            assert_eq!(material.quantity % EQUATIONS[equation_idx].right_side[0].quantity, 0);
            for element in EQUATIONS[equation_idx].left_side.iter() {
                if main_equation.left_side.contains(&element) {
                    for el in main_equation.left_side.iter_mut() {
                        if el.name == element.name {
                            el.quantity += element.quantity * multiplier;
                            break;
                        }
                    }
                } else {
                    main_equation.left_side.push( Material { name: element.name.clone(), quantity: element.quantity * multiplier } );
                }
            }

        }
        for element in EQUATIONS[main_equation_idx].left_side.iter() {
            println!("{:?}", element);
        }
        println!("Ore equations: {}", ORE_EQUATIONS.len());
    }
}

unsafe fn real_main() {
    let mut fuel_equation_idx = 9999999;
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
            ORE_EQUATIONS.push(EQUATIONS.len());
        }
        if is_fuel_equation {
            fuel_equation_idx = EQUATIONS.len();
        }

        EQUATIONS.push(Equation { left_side: left, right_side: right });
    }

    for equation_idx in ORE_EQUATIONS.iter() {
        assert_eq!(EQUATIONS[*equation_idx].right_side.len(), 1);
        BASE_MATERIALS.push(EQUATIONS[*equation_idx].right_side[0].name.clone());
    }

    reduce_equation(fuel_equation_idx, true);
    while equation_queue.len() > 0 {
        let equation_idx = equation_queue.remove(0);
        println!("Reducing equation {}", equation_idx);
        reduce_equation(equation_idx, false);
    }

    println!("Fuel equation seems reduced. Let's move forward");

    for ore_equation_idx in ORE_EQUATIONS.iter() {
        let ore_equation = &EQUATIONS[*ore_equation_idx];
        for element in ore_equation.left_side.iter() {
            print!("{:?} ", element);
        }
        println!("= {:?}", ore_equation.right_side[0]);
    }


    let mut ore_quantity = 0;
    for element in EQUATIONS[fuel_equation_idx].left_side.iter() {
        let mut found = false;
        for ore_equation_idx in ORE_EQUATIONS.iter() {
            if element.name == EQUATIONS[*ore_equation_idx].right_side[0].name {
                let multiplier =  (element.quantity as f32 / EQUATIONS[*ore_equation_idx].right_side[0].quantity as f32).ceil() as i32;
                println!("{} {} {}", element.quantity, EQUATIONS[*ore_equation_idx].right_side[0].quantity, (element.quantity as f64 / EQUATIONS[*ore_equation_idx].right_side[0].quantity as f64).ceil() as i64);
                ore_quantity += EQUATIONS[*ore_equation_idx].left_side[0].quantity * multiplier;
                found = true;
                break;
            }
        }
        if !found {
            println!("Could not find {}", element.name);
            process::exit(1);
        }
    }
    println!("{}", ore_quantity);
}

fn main() {
    unsafe { real_main() }
}
