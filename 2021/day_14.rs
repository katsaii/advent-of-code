use std::{ fs, collections::HashMap };

type Polymer = Vec<char>;
type InsertionRules = HashMap<(char, char), char>;

fn apply_rules(poly : &mut Polymer, rules : &InsertionRules) {
    let mut substitutions = Vec::new();
    for i in 1..(poly.len()) {
        let a = poly[i - 1];
        let b = poly[i];
        if let Some(replacement) = rules.get(&(a, b)) {
            substitutions.push((i, replacement));
        }
    }
    for (i, replacement) in substitutions {
        poly.insert(i, *replacement);
    }
}

fn tally_polymer(poly : &Polymer) -> HashMap<char, usize> {
    let mut tally = HashMap::new();
    for chr in poly {
        *tally.entry(*chr).or_insert(0) += 1;
    }
    tally
}

fn main() {
    let content = fs::read_to_string("in/day_14.txt").unwrap();
    let mut lines = content.lines();
    let mut poly = lines.next().unwrap().chars().collect::<Polymer>();
    lines.next();
    let mut rules = HashMap::new();
    for line in lines {
        let mut record = line.chars();
        let a = record.next().unwrap();
        let b = record.next().unwrap();
        let replacement = record.skip(4).next().unwrap();
        rules.insert((a, b), replacement);
    }
    for _ in 0..100 {
        apply_rules(&mut poly, &rules);
        println!("hi");
    }
    let tally = tally_polymer(&poly);
    let most = tally.iter().max_by(|a, b| a.1.cmp(&b.1)).unwrap();
    let least = tally.iter().min_by(|a, b| a.1.cmp(&b.1)).unwrap();
    print!("difference between most common ({}={}) ", most.0, most.1);
    print!("and least common ({}={}) ", least.0, least.1);
    println!("elements\n{}", most.1 - least.1);
}
