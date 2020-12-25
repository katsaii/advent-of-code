use std::{
    fs,
    collections::{ HashMap, HashSet },
    hash::Hash,
    cmp::Eq
};

type Cell3D = (isize, isize, isize);
type Cell4D = (isize, isize, isize, isize);
type Culture<T> = HashSet<T>;

trait Cellular : Sized + Hash + Eq {
    fn neighbourhood(&self) -> Vec<Self>;
    fn spawn(x : isize, y : isize) -> Self;
}

impl Cellular for Cell3D {
    fn neighbourhood(&self) -> Vec<Self> {
        let (x, y, z) = *self;
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

    fn spawn(x : isize, y : isize) -> Self {
        (x, y, 0)
    }
}

impl Cellular for Cell4D {
    fn neighbourhood(&self) -> Vec<Self> {
        let (x, y, z, w) = *self;
        let mut neighbourhood = Vec::new();
        for i in -1..=1 {
            for j in -1..=1 {
                for k in -1..=1 {
                    for l in -1..=1 {
                        if i == 0 && j == 0 && k == 0 && l == 0 {
                            continue;
                        }
                        neighbourhood.push((x + i, y + j, z + k, w + l));
                    }
                }
            }
        }
        neighbourhood
    }

    fn spawn(x : isize, y : isize) -> Self {
        (x, y, 0, 0)
    }
}

fn next_state<T : Cellular>(culture : Culture<T>) -> Culture<T> {
    let mut new_culture = HashSet::new();
    let mut neighbour_counts = HashMap::new();
    for cell in &culture {
        for neighbour in cell.neighbourhood() {
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

fn nth_state<T : Cellular>(mut culture : Culture<T>, n : isize) -> Culture<T> {
    for _ in 1..=n {
        culture = next_state(culture);
    }
    culture
}

fn load_culture<T : Cellular>(map : &str) -> Culture<T> {
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
                let cell = Cellular::spawn(i as isize, j as isize);
                culture.insert(cell);
            }
        }
    }
    culture
}

fn main() {
    let content = fs::read_to_string("in/day_17.txt").unwrap();
    let culture = load_culture::<Cell4D>(&content);
    let culture_6 = nth_state(culture, 6);
    println!("{:?}", culture_6.len());
}
