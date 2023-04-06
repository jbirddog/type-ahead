# TODOs

1. Replace the embedded shell scripts in the Makefile with the trick used to get the db
1. Add unit tests for db lib
1. Add integration tests, run same cases against actix/lambda frontends
   1. https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-using-invoke.html
   1. https://gallery.ecr.aws/lambda/provided - like connector-proxy-lambda-demo
1. Look at moving actix/lambda images to alpine like the lambda one
   1. segfaults, probably with sqlite?
   1. can try again now that sqlite is bundled
1. Split out the docker-compose.yml file
1. Rename dev to debug, copy the files in and use volumes as dev container
1. Custom github action?
1. Look at tagging images so the docker file can use local or pulled from ghcr.io
   1. How does this work with actions?
1. criterion benchmarking for data_layer vs current sqlite
1. Move r2d2/rusqlite out of the frontends so they only exist in db/data_layer