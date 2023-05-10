use lambda_http::{run, service_fn, Body, Error, Request, RequestExt, Response};
use r2d2_sqlite::{self, SqliteConnectionManager};
use serde_json::json;

use type_ahead_db::{execute, Pool, Query};

// TODO: will need a higher level dispatcher to handle liveness/discoverability endpoints
fn query_for_request(event: Request) -> Option<Query> {
    let prefix = event
        .query_string_parameters()
        .first("prefix")
        .unwrap()
        .to_string();
    let limit: i32 = event
        .query_string_parameters()
        .first("limit")
        .unwrap_or_else(|| "100")
        .parse()
        .unwrap();

    match event.raw_http_path().as_str() {
        "/v1/typeahead/cities" => Some(Query::CityNamesStartingWith(prefix, limit)),
        "/v1/typeahead/states" => Some(Query::StateNamesStartingWith(prefix, limit)),
        "/v1/typeahead/countries" => Some(Query::CountryNamesStartingWith(prefix, limit)),
        &_ => None,
    }
}

/// This is the main body for the function.
/// Write your code inside it.
/// There are some code example in the following URLs:
/// - https://github.com/awslabs/aws-lambda-rust-runtime/tree/main/examples
async fn function_handler(event: Request) -> Result<Response<Body>, Error> {
    // Extract some useful information from the request

    // TODO: look at the possibility of the connection pool being re-used?
    // TODO: better handle errors vs the unwraps
    let manager = SqliteConnectionManager::file("data.db");
    let pool = Pool::new(manager).unwrap();
    let conn = pool.get().unwrap();

    let query = query_for_request(event).unwrap();

    let response = execute(conn, query).unwrap();
    let response_str = json!(response).to_string();

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
