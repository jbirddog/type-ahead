use std::{env, fs, path::Path};

fn main() {
    let mut code_str = String::from("static COUNTRIES: [&'static str;3] = [\n");
    code_str.push_str("\"Canada\",\n");
    code_str.push_str("\"England\",\n");
    code_str.push_str("\"United States\",\n");
    code_str.push_str("];\n");

    let out_dir = env::var("OUT_DIR").unwrap();
    let dest_path = Path::new(&out_dir).join("data_countries.rs");
    fs::write(&dest_path, code_str).unwrap();
}
