use actix_web::{error, web, Error};
use serde::{Deserialize, Serialize};

pub type Connection = r2d2::PooledConnection<r2d2_sqlite::SqliteConnectionManager>;
pub type Pool = r2d2::Pool<r2d2_sqlite::SqliteConnectionManager>;

pub enum Query {
    // TODO: String vs &str
    CountryNamesStartingWith(String, i32),
}

#[derive(Debug, Serialize, Deserialize)]
pub enum Data {
    #[serde(rename = "name")]
    Name(String),
}

type QueryResult = Result<Vec<Data>, rusqlite::Error>;

pub async fn execute(pool: &Pool, query: Query) -> Result<Vec<Data>, Error> {
    let pool = pool.clone();

    let conn = web::block(move || pool.get())
        .await?
        .map_err(error::ErrorInternalServerError)?;

    web::block(move || match query {
        Query::CountryNamesStartingWith(prefix, limit) => {
            find_countries_starting_with(conn, prefix, limit)
        }
    })
    .await?
    .map_err(error::ErrorInternalServerError)
}

fn find_countries_starting_with(conn: Connection, prefix: String, limit: i32) -> QueryResult {
    let mut stmt = conn.prepare(
        "SELECT name 
    FROM countries
    WHERE name LIKE ? || '%'
    ORDER BY name
    LIMIT ?",
    )?;

    stmt.query_map(rusqlite::params![prefix, limit], |row| {
        Ok(Data::Name(row.get(0)?))
    })
    .and_then(Iterator::collect)
}
