use std::{
    fs,
    collections::{ HashMap, HashSet }
};

type Cell = (isize, isize, isize);
type Culture = HashSet<Cell>;

fn cell_neighbourhood((x, y, z) : Cell) -> Vec<Cell> {
    let mut neighbourhood = Vec::new();
    for i in -1..=1 {
        for j in -1..=1 {
            for k in -1..=1 {
                if i == 0 && j == 0 && k == 0 {
                    continue;
                }
                neighbourhood.push((x + i, y + j, z + k));
            }
        }
    }
    neighbourhood
}

fn next_state(culture : Culture) -> Culture {
    let new_culture = HashSet::new();
    //let neighbour_counts = HashMap::new();
    for cell in &culture {

    }
    new_culture
}

fn load_culture(map : &str) -> Culture {
    let mut culture = HashSet::new();
    for (j, line) in map
            .clone()
            .trim()
            .split('\n')
            .enumerate() {
        for (i, ch) in line
                .chars()
                .enumerate() {
            if ch == '#' {
                culture.insert((i as isize, j as isize, 0));
            }
        }
    }
    culture
}

fn main() {
    let content = fs::read_to_string("in/day_17.txt").unwrap();
    let culture = load_culture(&content);
    println!("{:?}", cell_neighbourhood((1, 4, 5)));
}
