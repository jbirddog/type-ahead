FROM type-ahead-data AS data
FROM type-ahead-debug AS debug

COPY --from=data /app/data.db data/data.db

 #ghcr.io/jbirddog/type-ahead-data:pr-1 AS data