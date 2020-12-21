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

impl Grammar {
    fn matches(&self, word : &str) -> bool {
        matches!(self.check(0, word), Some(""))
    }

    fn check<'a>(&self, id : usize, word : &'a str) -> Option<&'a str> {
        match self.productions.get(&id)? {
            Production::Nonterminal(production) => {
            'search:
                for rule in production {
                    let mut word_slice = word;
                    for nonterminal in rule {
                        if let Some(s) = self.check(*nonterminal, word_slice) {
                            word_slice = s;
                        } else {
                            continue 'search;
                        }
                    }
                    return Some(word_slice);
                }
            },
            Production::Terminal(ch) => {
                if word.chars().nth(0)? == *ch {
                    return Some(&word[1..]);
                }
            }
        }
        None
    }
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
            productions.insert(id, production);
        }
        Grammar { productions }
    }
}

fn count_matches(grammar : &Grammar, src : &str) -> usize {
    src.lines()
            .filter(|word| grammar.matches(word))
            .count()
}

fn main() {
    let content = fs::read_to_string("in/day_19.txt").unwrap();
    let (rules, words) = break_pair(content.trim(), "\n\n");
    let mut grammar = Grammar::from(rules);
    let match_count = count_matches(&grammar, words);
    println!("number of matches for this grammar\n{}", match_count);
}
