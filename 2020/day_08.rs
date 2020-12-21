use std::fs;
use std::collections::HashSet;

fn run_program(prog : &[(String, isize)]) -> Result<isize, isize> {
    let mut acc = 0;
    let mut pc = 0;
    let max = prog.len();
    let mut seen_instruction = HashSet::new();
    loop {
        if pc >= max {
            break;
        }
        if seen_instruction.contains(&pc) {
            return Err(acc);
        } else {
            seen_instruction.insert(pc);
        }
        let code = &prog[pc];
        let op = &code.0 as &str;
        let val = code.1;
        match op {
            "acc" => {
                acc += val;
            },
            "jmp" => {
                let off = val.abs() as usize;
                if val > 0 {
                    pc += off;
                } else {
                    pc -= off;
                }
                continue;
            },
            "nop" => (),
            _     => unreachable!()
        }
        pc += 1;
    }
    Ok(acc)
}

fn flip_code(mut code : &mut (String, isize)) {
    let flip = match &code.0 as &str {
        "nop" => "jmp".to_string(),
        "jmp" => "nop".to_string(),
        _     => return
    };
    code.0 = flip;
}

fn brute_force(prog : &mut [(String, isize)]) -> Option<isize> {
    let mut code_id = 0;
    let max = prog.len();
    loop {
        if code_id >= max {
            break;
        }
        flip_code(&mut prog[code_id]);
        if let Ok(acc) = run_program(prog) {
            return Some(acc);
        }
        flip_code(&mut prog[code_id]);
        code_id += 1;
    }
    None
}

fn main() {
    let mut content = fs::read_to_string("in/day_08.txt").unwrap();
    content.pop(); // pop newline off of file contents
    let mut codes = content
            .split('\n')
            .map(|x| {
                let vec = x.split(" ").collect::<Vec<_>>();
                (vec[0].to_string(), vec[1].parse::<isize>().unwrap())
            })
            .collect::<Vec<_>>();
    let error_acc = run_program(&mut codes).unwrap_err();
    println!("program repeats with an accumulator of\n{}", error_acc);
    let recovered_acc = brute_force(&mut codes).unwrap();
    println!("\naccumulator result recovered from corrupted program\n{}", recovered_acc);
}
