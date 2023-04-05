pub enum Data {
    Country {
        name: &'static str,
    },
    State {
        name: String,
        country: String,
    },
    City {
        name: String,
        state: String,
        country: String,
    },
}

// static COUNTRIES: [&'static str; 3] = ["Canada", "England", "United States"];

include!(concat!(env!("OUT_DIR"), "/data_countries.rs"));

pub fn add(left: usize, right: usize) -> &'static str {
    COUNTRIES[left + right]
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(0, 1);
        assert_eq!(result, "England");
    }
}
