use actix_web::{web, App, HttpResponse, HttpServer, Responder};
use r2d2_sqlite::{self, SqliteConnectionManager};
use serde::Deserialize;

// TODO: crate setup
mod db;
use db::Pool;

// TODO move the handlers out
async fn hello() -> impl Responder {
    // TODO: load demo index.html page
    HttpResponse::Ok().body("Hello.")
}

#[derive(Deserialize)]
struct TypeAheadParams {
    prefix: String,
    limit: i32,
}

async fn find_cities_starting_with(
    db: web::Data<Pool>,
    query_params: web::Query<TypeAheadParams>,
) -> Result<HttpResponse, actix_web::Error> {
    let query =
        db::Query::CityNamesStartingWith(query_params.prefix.to_string(), query_params.limit);
    let result = db::execute(&db, query).await?;

    Ok(HttpResponse::Ok().json(result))
}

async fn find_countries_starting_with(
    db: web::Data<Pool>,
    query_params: web::Query<TypeAheadParams>,
) -> Result<HttpResponse, actix_web::Error> {
    let query =
        db::Query::CountryNamesStartingWith(query_params.prefix.to_string(), query_params.limit);
    let result = db::execute(&db, query).await?;

    Ok(HttpResponse::Ok().json(result))
}

async fn find_states_starting_with(
    db: web::Data<Pool>,
    query_params: web::Query<TypeAheadParams>,
) -> Result<HttpResponse, actix_web::Error> {
    let query =
        db::Query::StateNamesStartingWith(query_params.prefix.to_string(), query_params.limit);
    let result = db::execute(&db, query).await?;

    Ok(HttpResponse::Ok().json(result))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // TODO: config all the things
    // TODO: logging
    let manager = SqliteConnectionManager::file("data/data.db");
    let pool = Pool::new(manager).unwrap();

    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            // TODO: build the routes separately
            .service(web::resource("/").route(web::get().to(hello)))
            // TODO: /v1/type-aheads discoverability endpoint
            // TODO: can the /v1/type-ahead endpoints be grouped?
            .service(
                web::resource("/v1/type-ahead/cities")
                    .route(web::get().to(find_cities_starting_with)),
            )
            .service(
                web::resource("/v1/type-ahead/countries")
                    .route(web::get().to(find_countries_starting_with)),
            )
            .service(
                web::resource("/v1/type-ahead/states")
                    .route(web::get().to(find_states_starting_with)),
            )
    })
    .bind(("0.0.0.0", 5000))?
    .run()
    .await
}
