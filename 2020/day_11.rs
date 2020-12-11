use std::fs;

type Field = Vec<Vec<char>>;
type Mutations = Vec<(usize, usize)>;

fn get_mutations(field : &Field, threshold : usize) -> Mutations {
    let mut mutations = Vec::new();
    let h = field.len();
    for (y, line) in field.iter().enumerate() {
        let w = line.len();
    'search:
        for (x, ch) in line.iter().enumerate() {
            let mut adjacent = Vec::new();
            if x > 0 {
                if y > 0 {
                    adjacent.push((x - 1, y - 1));
                }
                adjacent.push((x - 1, y));
                if y < h {
                    adjacent.push((x - 1, y + 1));
                }
            }
            if y > 0 {
                adjacent.push((x, y - 1));
            }
            if y < h {
                adjacent.push((x, y + 1));
            }
            if x < w {
                if y > 0 {
                    adjacent.push((x + 1, y - 1));
                }
                adjacent.push((x + 1, y));
                if y < h {
                    adjacent.push((x + 1, y + 1));
                }
            }
            let mut count = 0;
            for (ax, ay) in adjacent {
                if let Some('#') = field.get(ay).and_then(|line| line.get(ax)) {
                    count += 1;
                }
            }
            match ch {
                'L' => if count != 0 {
                    continue 'search;
                },
                '#' => if count < threshold {
                    continue 'search;
                },
                _   => continue 'search
            }
            mutations.push((x, y))
        }
    }
    mutations
}

fn apply_mutations(mutations : Mutations, field : &mut Field) {
    for (x, y) in mutations {
        let opposite = match field[y][x] {
            'L' => '#',
            '#' => 'L',
            x   => x
        };
        field[y][x] = opposite;
    }
}

fn simulate_seating(field : &Field, threshold : usize) -> usize {
    let mut field = field.clone();
    loop {
        let mutations = get_mutations(&field, threshold);
        if mutations.len() == 0 {
            break;
        }
        apply_mutations(mutations, &mut field);
    }
    let mut seat_count = 0;
    for line in field {
        for ch in line {
            if ch == '#' {
                seat_count += 1;
            }
        }
    }
    seat_count
}

fn main() {
    let mut content = fs::read_to_string("in/day_11.txt").unwrap();
    content.pop(); // pop newline off of file contents
    let mut field = content
            .split('\n')
            .map(|x| x.chars().collect())
            .collect::<Field>();
    let naive_seat_count = simulate_seating(&field, 4);
    println!("occupied seat count\n{}", naive_seat_count);
}
