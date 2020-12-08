use std::fs;

pub fn run_intcode(codes : &mut [usize]) -> Option<()> {
    let len = codes.len();
    let mut pc = 0;
    loop {
        if pc >= len {
            break None;
        }
        let code = *codes.get(pc)?;
        match code {
            1  => {
                let a = *codes.get(*codes.get(pc + 1)?)?;
                let b = *codes.get(*codes.get(pc + 2)?)?;
                let dest = *codes.get(pc + 3)?;
                codes[dest] = a + b;
            },
            2  => {
                let a = *codes.get(*codes.get(pc + 1)?)?;
                let b = *codes.get(*codes.get(pc + 2)?)?;
                let dest = *codes.get(pc + 3)?;
                codes[dest] = a * b;
            }
            99 => break Some(()),
            _  => break None
        }
        pc += 4;
    }
}

pub fn check_intcode(codes : &[usize], noun : usize, verb : usize) -> Option<usize> {
    let mut codes = codes.to_vec();
    codes[1] = noun;
    codes[2] = verb;
    run_intcode(&mut codes)?;
    Some(codes[0])
}

pub fn sat_intcode(codes : &[usize], target : usize) -> Option<(usize, usize)> {
    for noun in 0..99 {
        for verb in 0..99 {
            if let Some(result) = check_intcode(codes, noun, verb) {
                if result == target {
                    return Some((noun, verb));
                }
            }
        }
    }
    None
}

pub fn main() {
    let mut content = fs::read_to_string("in/day_2.txt").unwrap();
    content.pop(); // pop newline off of file contents
    let codes = content
            .split(',')
            .map(|x| x.parse::<usize>().unwrap())
            .collect::<Vec<_>>();
    let result = check_intcode(&codes, 12, 2).unwrap();
    println!("result of the 1202 alarm intcode computation\n{:?}", result);
    let target = 19690720;
    let params = sat_intcode(&codes, target).unwrap();
    println!("\nthe noun and verb pair {:?} produce the output {}", params, target);
    println!("100 * {} + {} = {}", params.0, params.1, 100 * params.0 + params.1);
}
