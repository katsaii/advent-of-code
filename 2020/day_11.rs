/*use std::fs;

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
}*/

use std::fs;
use std::collections::{ VecDeque, HashMap };

type Grid<T> = Vec<Vec<T>>;
type Seating = Vec<(bool, Vec<usize>)>;
type Mutations = Vec<usize>;

static DIRECTIONS : [(isize, isize); 8] = [(0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1)];

fn find_neighbour(grid : &Grid<char>, x : usize, y : usize, orientation : usize) -> Option<(usize, usize)> {
    let (dx, dy) = DIRECTIONS[orientation];
    if dx == -1 && x == 0 || dy == -1 && y == 0 {
        return None;
    }
    let tx = (x as isize + dx) as usize;
    let ty = (y as isize + dy) as usize;
    let ch = grid.get(ty)?.get(tx)?;
    if matches!(ch, '.') {
        None
    } else {
        Some((tx, ty))
    }
}

fn find_neighbours(grid : &Grid<char>, x : usize, y : usize) -> Vec<(usize, usize)> {
    (0..8).map(|i| find_neighbour(grid, x, y, i))
            .filter(|x| x.is_some())
            .map(|x| x.unwrap())
            .collect()
}

fn load_seating(map : String) -> Seating {
    let grid = map
            .trim()
            .split('\n')
            .map(|x| x.chars().collect())
            .collect::<Grid<char>>();
    let mut stack = Vec::new();
    for (y, line) in grid.iter().enumerate() {
    'search:
        for (x, ch) in line.iter().enumerate() {
            if matches!(ch, '.') {
                continue 'search;
            }
            stack.push((x, y));
        }
    }
    let mut seat_id = HashMap::new();
    let mut seating = Vec::new();
    while let Some(pos) = stack.pop() {
        if seat_id.contains_key(&pos) {
            continue;
        }
        let id = seating.len();
        seat_id.insert(pos, id);
        let neighbours = find_neighbours(&grid, pos.0, pos.1);
        seating.push((pos.clone(), neighbours.clone()));
        for neighbour in neighbours {
            stack.push(neighbour);
        }
    }
    seating.iter()
            .map(|((x, y), neighbours)| {
                let occupied = matches!(grid[*y][*x], '#');
                let neighbours = neighbours.iter()
                        .map(|pos| *seat_id.get(pos).unwrap())
                        .collect::<Vec<usize>>();
                (occupied, neighbours)
            })
            .collect()
}

fn seating_find_mutations(seating : &Seating) -> Mutations {
    let mut mutations = Vec::new();
    for (i, seat) in seating.iter().enumerate() {
        let count = seat.1.iter()
                .filter(|neighbour| seating[**neighbour].0)
                .count();
        if seat.0 {
            if count < 4 {
                continue;
            }
        } else {
            if count != 0 {
                continue;
            }
        }
        mutations.push(i);
    }
    mutations
}

fn seating_apply_mutations(seating : &mut Seating, mutations : Mutations) {
    for i in mutations {
        let occupied = seating[i].0;
        seating[i].0 = !occupied;
    }
}

fn seating_simulate(seating : &Seating) -> usize {
    let mut seating = seating.clone();
    loop {
        let mutations = seating_find_mutations(&seating);
        if mutations.len() == 0 {
            break;
        }
        seating_apply_mutations(&mut seating, mutations);
    }
    seating.iter()
            .filter(|(occupied, _)| *occupied)
            .count()
}

fn main() {
    let mut content = fs::read_to_string("in/day_11.txt").unwrap();
    let seating = load_seating(content);
    let naive_seat_count = seating_simulate(&seating);
    println!("naive occupied seat count\n{}", naive_seat_count);

    /*content.pop(); // pop newline off of file contents
    let mut field = content
            .split('\n')
            .map(|x| x.chars().collect())
            .collect::<Field>();
    let naive_seat_count = simulate_seating(&field, 4);
    println!("occupied seat count\n{}", naive_seat_count);*/

}
