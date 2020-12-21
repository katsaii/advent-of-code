use std::{ fs, collections::HashMap };

fn break_pair<'a>(s : &'a str, pat : &str) -> (&'a str, &'a str) {
    let mut split = s.splitn(2, pat);
    let fst = split.next().unwrap_or("");
    let snd = split.next().unwrap_or("");
    (fst, snd)
}

#[derive(Debug)]
enum Production {
    Nonterminal(Vec<Vec<usize>>),
    Terminal(char)
}

struct Grammar {
    productions : HashMap<usize, Production>
}

impl From<&str> for Grammar {
    fn from(s : &str) -> Self {
        let mut productions = HashMap::new();
        for line in s.lines() {
            let (name, rule) = break_pair(line, ": ");
            let id = name.parse::<usize>().unwrap_or(0);
            let production = if matches!(rule.chars().nth(0), Some('"')) {
                Production::Terminal(rule.chars().nth(1).unwrap_or('a'))
            } else {
                let nonterminal = rule.split(" | ")
                        .map(|subrule| {
                            subrule.split(' ')
                                    .map(|x| x.parse::<usize>().unwrap_or(0))
                                    .collect()
                        })
                        .collect::<Vec<Vec<usize>>>();
                Production::Nonterminal(nonterminal)
            };
            println!("{:?} {:?}", id, production);
            productions.insert(id, production);
        }
        Grammar { productions }
    }
}

fn main() {
    let content = fs::read_to_string("in/day_19.txt").unwrap();
    let (rules, words) = break_pair(content.trim(), "\n\n");
    let grammar = Grammar::from(rules);
}
