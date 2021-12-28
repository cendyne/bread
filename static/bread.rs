struct Glitch {
    mouth: Vec<&'static str>,
}

impl Glitch {
    fn new() -> Self {
        Glitch { mouth: Vec::new() }
    }
}

fn main() -> ! {
    let mut glitch = Glitch::new();
    loop {
        glitch.mouth.push("baguette");
    }
}
