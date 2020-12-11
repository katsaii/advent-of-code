use std::fs;

type Field = Vec<Vec<char>>;
type Mutations = Vec<(usize, usize)>;

fn get_adjacent(x : usize, y : usize, w : usize, h : usize) -> Mutations {
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
    adjacent
}

fn get_mutations(field : &Field) -> Mutations {
    let mut mutations = Vec::new();
    let h = field.len();
    for (y, line) in field.iter().enumerate() {
        let w = line.len();
    'search:
        for (x, ch) in line.iter().enumerate() {
            match ch {
                'L' => {
                    for (ax, ay) in get_adjacent(x, y, w, h) {
                        if let Some('#') = field.get(ay).and_then(|line| line.get(ax)) {
                            continue 'search;
                        }
                    }
                },
                '#' => {
                    let mut count = 0;
                    for (ax, ay) in get_adjacent(x, y, w, h) {
                        if let Some('#') = field.get(ay).and_then(|line| line.get(ax)) {
                            count += 1;
                        }
                    }
                    if count < 4 {
                        continue 'search;
                    }
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

fn simulate_seating(field : &mut Field) {
    loop {
        let mutations = get_mutations(field);
        if mutations.len() == 0 {
            break;
        }
        apply_mutations(mutations, field);
    }
}

fn main() {
    let mut content = fs::read_to_string("in/day_11.txt").unwrap();
    content.pop(); // pop newline off of file contents
    let mut field = content
            .split('\n')
            .map(|x| x.chars().collect())
            .collect::<Field>();
    simulate_seating(&mut field);
    let mut seat_count = 0;
    for line in field {
        for ch in line {
            if ch == '#' {
                seat_count += 1;
            }
        }
    }
    println!("occupied seat count\n{}", seat_count);
}
