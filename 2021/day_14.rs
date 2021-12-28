use std::{ fs, collections::HashMap, hash::Hash };

fn inc_key<T : Hash + Eq>(map : &mut HashMap<T, usize>, key : T, amount : usize) {
    *map.entry(key).or_insert(0) += amount;
}

struct Polymer {
    char_map : HashMap<char, usize>,
    pair_map : HashMap<(char, char), usize>,
    rules : HashMap<(char, char), char>,
}

impl Polymer {
    fn load(src : &str) -> Option<Self> {
        let mut lines = src.lines();
        let mut char_map = HashMap::new();
        let mut pair_map = HashMap::new();
        let mut rules = HashMap::new();
        let initial_state : Vec<_> = lines.next()?.chars().collect();
        for i in 0..(initial_state.len()) {
            let chr = initial_state[i];
            if i > 0 {
                let chr_prev = initial_state[i - 1];
                inc_key(&mut pair_map, (chr_prev, chr), 1);
            }
            inc_key(&mut char_map, chr, 1);
        }
        lines.next();
        for line in lines {
            let mut record = line.chars();
            let a = record.next()?;
            let b = record.next()?;
            let replacement = record.skip(4).next()?;
            rules.insert((a, b), replacement);
        }
        Some(Self { char_map, pair_map, rules })
    }

    fn apply_rules(&mut self, n : usize) {
        for _ in 0..n {
            let mut substitutions = Vec::new();
            for (&pair, &count) in &self.pair_map {
                if let Some(&replacement) = self.rules.get(&pair) {
                    substitutions.push((pair, replacement, count));
                }
            }
            for (pair, ..) in &substitutions {
                self.pair_map.remove(pair);
            }
            for (pair, replacement, count) in substitutions {
                inc_key(&mut self.pair_map, (pair.0, replacement), count);
                inc_key(&mut self.pair_map, (replacement, pair.1), count);
                inc_key(&mut self.char_map, replacement, count);
            }
        }
    }

    fn frequencies(&self) -> Option<((char, usize), (char, usize))> {
        let lo = self.char_map.iter().min_by(|a, b| a.1.cmp(&b.1))?;
        let hi = self.char_map.iter().max_by(|a, b| a.1.cmp(&b.1))?;
        Some(((*lo.0, *lo.1), (*hi.0, *hi.1)))
    }
}

fn main() {
    let content = fs::read_to_string("in/day_14.txt").unwrap();
    let mut poly = Polymer::load(&content).unwrap();
    poly.apply_rules(10);
    let (lo, hi) = poly.frequencies().unwrap();
    print!("difference between most common ({}={}) ", hi.0, hi.1);
    print!("and least common ({}={}) ", lo.0, lo.1);
    println!("elements after 10 iterations\n{}", hi.1 - lo.1);
    poly.apply_rules(30);
    let (lo, hi) = poly.frequencies().unwrap();
    print!("\ndifference between most common ({}={}) ", hi.0, hi.1);
    print!("and least common ({}={}) ", lo.0, lo.1);
    println!("elements after 40 iterations\n{}", hi.1 - lo.1);
}
