use std::{
    fs, cmp,
    collections::{ VecDeque, HashMap }
};

type Grid<T> = Vec<Vec<T>>;
type Seating = Vec<(bool, Vec<usize>)>;
type Mutations = Vec<usize>;

static DIRECTIONS : [(isize, isize); 8] = [(0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1)];

fn find_neighbour(grid : &Grid<char>, mut x : usize, mut y : usize, orientation : usize, dist : usize) -> Option<(usize, usize)> {
    let (dx, dy) = DIRECTIONS[orientation];
    for _ in 1..=dist {
        if dx == -1 && x == 0 || dy == -1 && y == 0 {
            return None;
        }
        x = (x as isize + dx) as usize;
        y = (y as isize + dy) as usize;
        let ch = grid.get(y)?.get(x)?;
        if !matches!(ch, '.') {
            return Some((x, y))
        }
    }
    None
}

fn find_neighbours(grid : &Grid<char>, x : usize, y : usize, dist : usize) -> Vec<(usize, usize)> {
    (0..8).map(|i| find_neighbour(grid, x, y, i, dist))
            .filter(|x| x.is_some())
            .map(|x| x.unwrap())
            .collect()
}

fn load_seating(map : &str, mdist : Option<usize>) -> Seating {
    let grid = map
            .clone()
            .trim()
            .split('\n')
            .map(|x| x.chars().collect())
            .collect::<Grid<char>>();
    let dist = if let Some(x) = mdist {
        x
    } else {
        let height = grid.len();
        let width = grid.iter()
                .map(|x| x.len())
                .max()
                .unwrap();
        cmp::max(height, width)
    };
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
        let neighbours = find_neighbours(&grid, pos.0, pos.1, dist);
        for neighbour in &neighbours {
            stack.push(neighbour.clone());
        }
        seating.push((pos.clone(), neighbours));
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

fn seating_find_mutations(seating : &Seating, threshold : usize) -> Mutations {
    let mut mutations = Vec::new();
    for (i, seat) in seating.iter().enumerate() {
        let count = seat.1.iter()
                .filter(|neighbour| seating[**neighbour].0)
                .count();
        if seat.0 {
            if count < threshold {
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

fn seating_simulate(seating : &mut Seating, threshold : usize) -> usize {
    loop {
        let mutations = seating_find_mutations(seating, threshold);
        //println!("{:?}", mutations);
        if mutations.len() == 0 {
            break;
        }
        seating_apply_mutations(seating, mutations);
    }
    seating.iter()
            .filter(|(occupied, _)| *occupied)
            .count()
}

fn main() {
    let content = fs::read_to_string("in/day_11.txt").unwrap();
    let naive_seat_count = seating_simulate(&mut load_seating(&content, Some(1)), 4);
    println!("naive occupied seat count\n{}", naive_seat_count);
    let correct_seat_count = seating_simulate(&mut load_seating(&content, None), 5);
    println!("\ncorrect occupied seat count\n{}", correct_seat_count);
}
