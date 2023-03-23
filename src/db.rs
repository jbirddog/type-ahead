use actix_web::{error, web, Error};
use serde::{Deserialize, Serialize};

pub type Connection = r2d2::PooledConnection<r2d2_sqlite::SqliteConnectionManager>;
pub type Pool = r2d2::Pool<r2d2_sqlite::SqliteConnectionManager>;

pub enum Query {
    // TODO: String vs &str
    CityNamesStartingWith(String, i32),
    CountryNamesStartingWith(String, i32),
    StateNamesStartingWith(String, i32),
}

#[derive(Debug, Serialize, Deserialize)]
pub enum Data {
    #[serde(rename = "countryName")]
    CountryName(String),
    #[serde(rename = "stateAndCountryName")]
    StateAndCountryName(String, String),
    #[serde(rename = "cityStateAndCountryName")]
    CityStateAndCountryName(String, String, String),
}

type QueryResult = Result<Vec<Data>, rusqlite::Error>;

pub async fn execute(pool: &Pool, query: Query) -> Result<Vec<Data>, Error> {
    let pool = pool.clone();

    let conn = web::block(move || pool.get())
        .await?
        .map_err(error::ErrorInternalServerError)?;

    web::block(move || match query {
        Query::CityNamesStartingWith(prefix, limit) => {
            find_cities_starting_with(conn, prefix, limit)
        }

        Query::CountryNamesStartingWith(prefix, limit) => {
            find_countries_starting_with(conn, prefix, limit)
        }

        Query::StateNamesStartingWith(prefix, limit) => {
            find_states_starting_with(conn, prefix, limit)
        }
    })
    .await?
    .map_err(error::ErrorInternalServerError)
}

fn find_cities_starting_with(conn: Connection, prefix: String, limit: i32) -> QueryResult {
    let mut stmt = conn.prepare(
        "SELECT name, state_name, country_name 
    FROM cities
    WHERE name LIKE ? || '%'
    ORDER BY name
    LIMIT ?",
    )?;

    stmt.query_map(rusqlite::params![prefix, limit], |row| {
        Ok(Data::CityStateAndCountryName(
            row.get(0)?,
            row.get(1)?,
            row.get(2)?,
        ))
    })
    .and_then(Iterator::collect)
}

// TODO: refactor countries/states_starting_with
fn find_countries_starting_with(conn: Connection, prefix: String, limit: i32) -> QueryResult {
    let mut stmt = conn.prepare(
        "SELECT name 
    FROM countries
    WHERE name LIKE ? || '%'
    ORDER BY name
    LIMIT ?",
    )?;

    stmt.query_map(rusqlite::params![prefix, limit], |row| {
        Ok(Data::CountryName(row.get(0)?))
    })
    .and_then(Iterator::collect)
}

fn find_states_starting_with(conn: Connection, prefix: String, limit: i32) -> QueryResult {
    let mut stmt = conn.prepare(
        "SELECT name, country_name 
    FROM states
    WHERE name LIKE ? || '%'
    ORDER BY name
    LIMIT ?",
    )?;

    stmt.query_map(rusqlite::params![prefix, limit], |row| {
        Ok(Data::StateAndCountryName(row.get(0)?, row.get(1)?))
    })
    .and_then(Iterator::collect)
}
