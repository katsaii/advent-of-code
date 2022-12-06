use std::{ fs, collections::HashSet };

fn packet_marker(packet : &[u8], size : usize) -> usize {
    for i in 0..packet.len() {
        if packet[i..(i + size)].iter().collect::<HashSet<_>>().len() == size {
            return i + size;
        }
    }
    unreachable!();
}

fn main() {
    let packet = fs::read_to_string("in/day_06.txt").unwrap().into_bytes();
    println!("start of packet\n{}", packet_marker(&packet, 4));
    println!("\nstart of message\n{}", packet_marker(&packet, 14));
}
