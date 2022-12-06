use std::{ fs, collections::HashSet };

const SIZE : usize = 4;

fn start_of_packet(packet : &[u8]) -> usize {
    for i in 0..(packet.len() - SIZE) {
        let window : HashSet<_> = packet[i..(i + SIZE)].iter().collect();
        if window.len() == SIZE {
            return i + SIZE;
        }
    }
    unreachable!();
}

fn main() {
    let packet = fs::read_to_string("in/day_06.txt").unwrap().into_bytes();
    println!("start of packet\n{}", start_of_packet(&packet));
}
