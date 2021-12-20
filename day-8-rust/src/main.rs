use itertools::Itertools;
use std::env;
use std::fs::File;
use std::io;
use std::io::BufRead;
use std::collections::HashSet;
use std::iter::FromIterator;
use std::path::Path;
use std::process;

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
  let file = File::open(filename)?;
  Ok(io::BufReader::new(file).lines())
}
 
const CANONICAL : [u8; 10] = [
  //abcdefg
  0b1110111,  // 0
  0b0010010,
  0b1011101,
  0b1011011,
  0b0111010,
  0b1101011,
  0b1101111,
  0b1010010,
  0b1111111,
  0b1111011,  // 9
];
 
fn pos<P : std::cmp::Eq>(haystack : &[P], needle : P) -> Option<usize> {
  for (i,p) in haystack.iter().enumerate() {
    if *p == needle { return Some(i) }
  }
  return None
}
 
fn encode(w : &str, perm : &[char]) -> u8 {
  let mut ret = 0u8;
  for c in w.chars() {
    match pos(perm, c) {
      Some(x) => {ret += 1u8 << x}
      None => {panic!("unexpected character")}
    }
  }
  return ret
}
 
fn find_code(wires : &[&str]) -> Vec::<char> {
  let canonical_values = HashSet::<u8>::from_iter(CANONICAL.iter().cloned());
  for perm in ['a', 'b', 'c', 'd', 'e', 'f', 'g'].iter().permutations(7) {
    let perm : Vec<char> = perm.into_iter().cloned().collect();
    let values : HashSet<u8> = wires.iter().map(|w| encode(w, &perm[..])).collect();
    if values == canonical_values {
      return perm
    }
  }
  panic!("Failed to find_code")
}
 
fn main() {
  let args: Vec<String> = env::args().collect();
  if args.len() < 2 {
    println!("No input file received");
    process::exit(0x0100);
  }
  
  let mut k : i32 = 0;
  if let Ok(lines) = read_lines(&args[1]) {
      for line in lines {
    // for line in io::stdin().lock().lines() {
      let line = String::from(line.unwrap());
      let words : Vec<&str> = line.trim().split_whitespace().collect();
      let code = find_code(&words[.. 10]);
      let mut num : i32 = 0;
      for w in &words[11 ..] {
        let e = encode(w, &code[..]);
        let digit = pos(&CANONICAL, e).unwrap();
        num = num*10 + (digit as i32);
      }
      k += num;
      println!("{} -> {}", line, num);
    }
  }
  println!("{}", k)
}
