use lambda_http::{run, service_fn, Body, Error, Request, Response}; //, RequestExt
use r2d2_sqlite::{self, SqliteConnectionManager};

use type_ahead_db::{execute, Pool, Query};

/// This is the main body for the function.
/// Write your code inside it.
/// There are some code example in the following URLs:
/// - https://github.com/awslabs/aws-lambda-rust-runtime/tree/main/examples
async fn function_handler(_event: Request) -> Result<Response<Body>, Error> {
    // Extract some useful information from the request

    let manager = SqliteConnectionManager::file("data.db");
    let pool = Pool::new(manager).unwrap();
    let conn = pool.get().unwrap();

    let query = Query::CityNamesStartingWith("marie".to_string(), 100);

    let response = execute(conn, query).unwrap();
    let response_str = serde_json::to_string(&response).unwrap();

    // Return something that implements IntoResponse.
    // It will be serialized to the right response event automatically by the runtime
    let resp = Response::builder()
        .status(200)
        .header("content-type", "application/json")
        .body(response_str.into())
        .map_err(Box::new)?;
    Ok(resp)
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    tracing_subscriber::fmt()
        .with_max_level(tracing::Level::INFO)
        .with_target(false)
        .without_time()
        .init();

    run(service_fn(function_handler)).await
}
