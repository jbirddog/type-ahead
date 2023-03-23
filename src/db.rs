use actix_web::{error, web, Error};
use serde::{Deserialize, Serialize};

pub type Connection = r2d2::PooledConnection<r2d2_sqlite::SqliteConnectionManager>;
pub type Pool = r2d2::Pool<r2d2_sqlite::SqliteConnectionManager>;

pub enum Query {
    CountryNamesStartingWith(String, i32),
}

#[derive(Debug, Serialize, Deserialize)]
pub enum Data {
    CountryName { name: String },
}

type QueryResult = Result<Vec<Data>, rusqlite::Error>;

pub async fn execute(pool: &Pool, query: Query) -> Result<Vec<Data>, Error> {
    let pool = pool.clone();

    let conn = web::block(move || pool.get())
        .await?
        .map_err(error::ErrorInternalServerError)?;

    web::block(move || match query {
    		    // TODO: pass in params from match instead of query
        Query::CountryNamesStartingWith(_, _) => find_countries_starting_with(conn, query),
    })
    .await?
    .map_err(error::ErrorInternalServerError)
}

fn find_countries_starting_with(conn: Connection, _query: Query) -> QueryResult {
    // TODO: bind params from query
    let mut stmt = conn.prepare(
        "SELECT name 
    FROM countries
    WHERE name LIKE 'Un%'
    ORDER BY name
    LIMIT 100",
    )?;

    stmt.query_map([], |row| Ok(Data::CountryName { name: row.get(0)? }))
        .and_then(Iterator::collect)
}
