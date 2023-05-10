use std::env;

macro_rules! env_var {
    ($suffix:literal) => {
        env::var(concat!("TYPEAHEAD_", $suffix)).ok()
    };
}

macro_rules! expose_env {
    (optional $suffix:literal is $fn:ident with default $default:literal) => {
        pub fn $fn() -> String {
            match env_var!($suffix) {
                Some(val) => val,
                _ => $default.to_string(),
            }
        }
    };
    (optional $suffix:literal is $fn:ident as $type:tt with default $default:literal) => {
        pub fn $fn() -> $type {
            match env_var!($suffix).and_then(|s| s.parse::<$type>().ok()) {
                Some(val) => val,
                _ => $default,
            }
        }
    };
}

expose_env!(optional "HOST" is host with default "0.0.0.0");
expose_env!(optional "PORT" is port as u16 with default 80);
