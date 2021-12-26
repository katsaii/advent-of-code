use std::collections::HashMap;

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

fn main() {
    let mut poly = "NNCB".chars().collect::<Polymer>();
    let mut rules = HashMap::new();
    rules.insert(('N', 'N'), 'N');
    apply_rules(&mut poly, &rules);
    apply_rules(&mut poly, &rules);
    println!("{:?}", poly);
}
