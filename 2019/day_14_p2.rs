use std::process;
use std::io;
use std::io::prelude::*;
use std::fmt;

struct Material {
    name: String,
    quantity: i32
}

impl fmt::Debug for Material {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}*{}", self.quantity, self.name)
    }
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

unsafe fn print_equation(equation_idx : usize) {
    let equation = &EQUATIONS[equation_idx];
    for element in equation.left_side.iter() {
        print!("{:?} ", element);
    }
    print!("= ");
    for element in equation.right_side.iter() {
        print!("{:?} ", element);
    }
    println!("");
}

unsafe fn eliminate_extras(equation_idx : usize) {
    let main_equation = &mut EQUATIONS[equation_idx];
    for left_element in main_equation.left_side.iter_mut() {
        for right_element in main_equation.right_side.iter_mut() {
            if right_element.name != left_element.name {
                continue;
            }
            if right_element.quantity > left_element.quantity {
                right_element.quantity -= left_element.quantity;
                left_element.quantity = 0;
            } else {
                left_element.quantity -= right_element.quantity;
                right_element.quantity = 0;
            }
        }
    }
    {
        let mut left_element_idx = 0;
        loop {
            if main_equation.left_side[left_element_idx].quantity == 0 {
                main_equation.left_side.remove(left_element_idx);
            } else {
                left_element_idx += 1;
            }
            if left_element_idx >= main_equation.left_side.len() {
                break
            }
        }
    }
    {
        let mut right_element_idx = 0;
        loop {
            if main_equation.right_side[right_element_idx].quantity == 0 {
                main_equation.right_side.remove(right_element_idx);
            } else {
                right_element_idx += 1;
            }
            if right_element_idx >= main_equation.right_side.len() {
                break
            }
        }
    }
}

unsafe fn reduce_equation(main_equation_idx : usize, ignore_ores : bool) {
    // Step 1: Convert all non-ORE elements into ORE elements
    let mut element_idx = 0;
    loop {
        if element_idx >= EQUATIONS[main_equation_idx].left_side.len() {
            break;
        }

        print_equation(main_equation_idx);
        println!("Looking at #{} : {:?}", element_idx, EQUATIONS[main_equation_idx].left_side[element_idx]);
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
            let material : Material;
            let main_equation = &mut EQUATIONS[main_equation_idx];
            println!("#{}",element_idx);
            material = main_equation.left_side.remove(element_idx);
            let multiplier;
            multiplier = (material.quantity as f32 / EQUATIONS[equation_idx].right_side[0].quantity as f32).ceil() as i32;
            let left_over = (EQUATIONS[equation_idx].right_side[0].quantity * multiplier) % material.quantity;
            let left_quantity = (EQUATIONS[equation_idx].right_side[0].quantity * multiplier) - left_over;
            let right_quantity = left_over;
            println!("Chose {} * {} ( {} = {} ) - ( {} / {} )", material.name, multiplier, left_quantity, right_quantity, material.quantity, EQUATIONS[equation_idx].right_side[0].quantity);
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
            if left_over > 0 {
                if main_equation.right_side.contains(&material) {
                    for el in main_equation.right_side.iter_mut() {
                        if el.name == material.name {
                            el.quantity += left_over;
                            break;
                        }
                    }
                } else {
                    main_equation.right_side.push( Material { name: material.name.clone(), quantity: left_over } );
                }
            }
        }
        eliminate_extras(main_equation_idx);
    }
}

unsafe fn real_main() {
    let fuel_equation_idx = 0;
    EQUATIONS.push(Equation { left_side: Vec::new(), right_side: Vec::new() });
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
        for material in parts[1].split(", ") {
            let mat_parts : Vec<&str> = material.split_whitespace().collect();
            assert_eq!(mat_parts.len(), 2);
            let qty : i32 = mat_parts[0].parse::<i32>().unwrap();
            let name  = mat_parts[1].to_string();
            right.push(Material { name: name, quantity: qty });
        }
        if is_ore_equation {
            ORE_EQUATIONS.push(EQUATIONS.len());
        } else {
            let main_equation = &mut EQUATIONS[fuel_equation_idx];
            for element in left.iter() {
                if main_equation.left_side.contains(&element) {
                    for el in main_equation.left_side.iter_mut() {
                        if el.name == element.name {
                            el.quantity += element.quantity;
                            break;
                        }
                    }
                } else {
                    main_equation.left_side.push( Material { name: element.name.clone(), quantity: element.quantity} );
                }
            }
            for element in right.iter() {
                if main_equation.right_side.contains(&element) {
                    for el in main_equation.right_side.iter_mut() {
                        if el.name == element.name {
                            el.quantity += element.quantity;
                            break;
                        }
                    }
                } else {
                    main_equation.right_side.push( Material { name: element.name.clone(), quantity: element.quantity} );
                }
            }
            print_equation(fuel_equation_idx);
        }
        EQUATIONS.push(Equation { left_side: left, right_side: right });
    }

    eliminate_extras(fuel_equation_idx);
    print_equation(fuel_equation_idx);

    for equation_idx in ORE_EQUATIONS.iter() {
        assert_eq!(EQUATIONS[*equation_idx].right_side.len(), 1);
        BASE_MATERIALS.push(EQUATIONS[*equation_idx].right_side[0].name.clone());
    }

    reduce_equation(fuel_equation_idx, true);
    print_equation(fuel_equation_idx);

    println!("Fuel equation seems reduced. Let's move forward");

    for ore_equation_idx in ORE_EQUATIONS.iter() {
        print_equation(*ore_equation_idx);
    }


    let mut fuel_quantity : i64 = 0;
    let mut ore_storage : i64 = 1000000000000;
    let mut i = 0;

    let mut leftover_equation : Vec<Material> = Vec::new();
    for element in EQUATIONS[fuel_equation_idx].left_side.iter() {
        leftover_equation.push(Material { name: element.name.clone(), quantity: 0 });
    }
    for element in EQUATIONS[fuel_equation_idx].right_side.iter() {
        leftover_equation.push(Material { name: element.name.clone(), quantity: 0 });
    }

    loop {
        let mut ore_quantity = 0;
        for element in EQUATIONS[fuel_equation_idx].left_side.iter() {
            let mut found = false;
            for ore_equation_idx in ORE_EQUATIONS.iter() {
                if element.name == EQUATIONS[*ore_equation_idx].right_side[0].name {
                    let mut quantity = element.quantity;

                    let multiplier;
                    multiplier = (quantity as f32 / EQUATIONS[*ore_equation_idx].right_side[0].quantity as f32).ceil() as i32;
                    let left_over = (EQUATIONS[*ore_equation_idx].right_side[0].quantity * multiplier) % quantity;
                    //println!("{} - {} {} {} - {}", element.name, quantity, EQUATIONS[*ore_equation_idx].right_side[0].quantity, (quantity as f64 / EQUATIONS[*ore_equation_idx].right_side[0].quantity as f64).ceil() as i64, left_over);
                    ore_quantity += EQUATIONS[*ore_equation_idx].left_side[0].quantity * multiplier;
                    if left_over > 0 {
                        for eq in leftover_equation.iter_mut() {
                            if eq.name == element.name {
                                eq.quantity += left_over;
                                break;
                            }
                        }
                    }
                    found = true;
                    break;
                }
            }
            if !found {
                println!("Could not find {}", element.name);
                process::exit(1);
            }
        }
        for element in EQUATIONS[fuel_equation_idx].right_side.iter() {
            for eq in leftover_equation.iter_mut() {
                if eq.name == element.name {
                    eq.quantity += element.quantity;
                    break;
                }
            }
        }
        if ore_quantity as i64 > ore_storage {
            break;
        }
        ore_storage -= ore_quantity as i64;
        fuel_quantity += 1;
        i+=1;
        if i % 1000 == 0 {
            println!("{} {}", ore_storage, fuel_quantity);
        }
    }
    println!("{} {}", ore_storage, fuel_quantity);
    for el in leftover_equation.iter() {
        println!("{:?}", el);
    }
}

fn main() {
    unsafe { real_main() }
}
