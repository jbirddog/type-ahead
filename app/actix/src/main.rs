use actix_web::middleware::Logger;
use actix_web::{error, web, App, HttpResponse, HttpServer, Responder};
use r2d2_sqlite::{self, SqliteConnectionManager};
use serde::Deserialize;

use type_ahead_db::{execute, Pool, Query};

mod config;

// TODO move the handlers out
async fn hello() -> impl Responder {
    // TODO: load demo index.html page
    HttpResponse::Ok().body("Hello there...")
}

#[derive(Deserialize)]
struct TypeAheadParams {
    prefix: String,
    limit: i32,
}

async fn execute_query(pool: &Pool, query: Query) -> Result<HttpResponse, actix_web::Error> {
    let pool = pool.clone();
    let conn = web::block(move || pool.get()).await?.unwrap(); // TODO: flat_map or similiar

    let result = web::block(move || execute(conn, query))
        .await?
        .map_err(error::ErrorInternalServerError)?;

    Ok(HttpResponse::Ok().json(result))
}

async fn find_cities_starting_with(
    pool: web::Data<Pool>,
    query_params: web::Query<TypeAheadParams>,
) -> Result<HttpResponse, actix_web::Error> {
    let query = Query::CityNamesStartingWith(query_params.prefix.to_string(), query_params.limit);

    execute_query(&pool, query).await
}

async fn find_countries_starting_with(
    pool: web::Data<Pool>,
    query_params: web::Query<TypeAheadParams>,
) -> Result<HttpResponse, actix_web::Error> {
    let query =
        Query::CountryNamesStartingWith(query_params.prefix.to_string(), query_params.limit);

    execute_query(&pool, query).await
}

async fn find_states_starting_with(
    pool: web::Data<Pool>,
    query_params: web::Query<TypeAheadParams>,
) -> Result<HttpResponse, actix_web::Error> {
    let query = Query::StateNamesStartingWith(query_params.prefix.to_string(), query_params.limit);

    execute_query(&pool, query).await
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let host = config::host();
    let port = config::port();

    let manager = SqliteConnectionManager::file("../artifacts/data.db");
    let pool = Pool::new(manager).unwrap();

    HttpServer::new(move || {
        App::new()
            .wrap(Logger::default())
            .app_data(web::Data::new(pool.clone()))
            // TODO: build the routes separately
            .service(web::resource("/").route(web::get().to(hello)))
            // TODO: /v1/typeaheads discoverability endpoint
            // TODO: can the /v1/typeahead endpoints be grouped?
            .service(
                web::resource("/v1/typeahead/cities")
                    .route(web::get().to(find_cities_starting_with)),
            )
            .service(
                web::resource("/v1/typeahead/countries")
                    .route(web::get().to(find_countries_starting_with)),
            )
            .service(
                web::resource("/v1/typeahead/states")
                    .route(web::get().to(find_states_starting_with)),
            )
    })
    .bind((host, port))?
    .run()
    .await
}
