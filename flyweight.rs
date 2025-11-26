use std::collections::HashMap;
use std::rc::Rc;

struct SnowflakeType {
    shape: String,
    texture: String,
    color: String,
}
impl SnowflakeType {
    fn new(shape: &str, texture: &str, color: &str)->Self {
        Self {
            shape: shape.to_string(),
            texture: texture.to_string(),
            color: color.to_string(),
        }
    }
    
    fn buildSnowflake(&self, density: f32)->String {
        format!("Type [shape: {}, texture: {}, color: {}] with density {:.2}", self.shape, self.texture, self.color, density)
    }
}

struct SnowflakeFactory {
    types: HashMap<String, Rc<SnowflakeType>>,
}
impl SnowflakeFactory {
    fn new()->Self {
        Self {
            types: HashMap::new(),
        }
    }
    fn getSnowflakeType(&mut self, shape: &str, texture: &str, color: &str)->Rc<SnowflakeType> {
        let key = format!("[shape: {}, texture: {}, color: {}]", shape, texture, color);
        if let Some(sftype) = self.types.get(&key) {
            Rc::clone(sftype)
        } else {
            let sftype = Rc::new(SnowflakeType::new(shape, texture, color));
            self.types.insert(key.clone(), Rc::clone(&sftype));
            sftype
        }
    }
}

struct Snowflake {
    density: f32,
    snowflakeType: Rc<SnowflakeType>,
}
impl Snowflake {
    fn new(density: f32, snowflakeType: Rc<SnowflakeType>)->Self {
        Self{density, snowflakeType}
    }
    
    fn buildSnowflake(&self)->String {
        self.snowflakeType.buildSnowflake(self.density)
    }
}

struct Particle {
    x: f32,
    y: f32,
    z: f32,
    snowflake: Rc<Snowflake>,
}
impl Particle {
    fn new(x: f32, y: f32, z:f32, snowflake: Rc<Snowflake>)->Self {
        Self {
            x,
            y,
            z,
            snowflake,
        }
    }
    
    fn render(&self) {
        println!(
            "Particle at ({:.2}, {:.2}, {:.2}) : {}",
            self.x, self.y, self.z, self.snowflake.buildSnowflake()
        );
    }
}

fn main() {
    let types = vec![
        ("star", "smooth", "white"),
        ("circle", "rough", "blue"),
    ];

    let mut factory = SnowflakeFactory::new();
    let mut particles: Vec<Particle> = Vec::new();

    for i in 0..10 {
        let (shape, texture, color) = types[i % types.len()];
        let density = 0.5 + (i as f32 * 0.1);
        let snowflake_type = factory.getSnowflakeType(shape, texture,color);
        let snowflake = Rc::new(Snowflake::new(density, snowflake_type));
        
        let particle = Particle::new(
            i as f32 * 10.0,
            100.0 - i as f32 * 5.0,
            0.0,
            snowflake,
        );
        particles.push(particle);
    }

    for p in &particles {
        p.render();
    }
}
