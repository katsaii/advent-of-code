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
    let mut new_culture = HashSet::new();
    let mut neighbour_counts = HashMap::new();
    for cell in &culture {
        for neighbour in cell_neighbourhood(*cell) {
            match neighbour_counts.get_mut(&neighbour) {
                Some(x) => {
                    *x += 1;
                },
                None => {
                    neighbour_counts.insert(neighbour, 1);
                }
            }
        }
    }
    for (cell, count) in neighbour_counts {
        if culture.contains(&cell) && matches!(count, 2 | 3) || count == 3 {
            new_culture.insert(cell);
        }
    }
    new_culture
}

fn nth_state(mut culture : Culture, n : isize) -> Culture {
    for _ in 1..=n {
        culture = next_state(culture);
    }
    culture
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
    let culture_6 = nth_state(culture, 6);
    println!("{:?}", culture_6.len());
}
