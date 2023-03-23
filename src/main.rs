use actix_web::{web, App, HttpResponse, HttpServer, Responder};
use r2d2_sqlite::{self, SqliteConnectionManager};

// TODO: crate setup
mod db;
use db::Pool;

// TODO move the handlers out
async fn hello() -> impl Responder {
    // TODO: load demo index.html page
    HttpResponse::Ok().body("Hello.")
}

async fn find_countries(_db: web::Data<Pool>) -> impl Responder {

    HttpResponse::Ok().body("countries...")
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
            .service(web::resource("/countries").route(web::get().to(find_countries)))
    })
    .bind(("0.0.0.0", 5000))?
    .run()
    .await
}
