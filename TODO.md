# TODOs

1. Confirm the db can be placed in the zip and read in the lambda
   1. - crashes when trying to interact with sqlite
   1. - same issues with using distroless for a release
1. Replace the embedded shell scripts in the Makefile with the trick used to get the db
1. Add unit tests for db lib
1. Add integration tests, run same cases against actix/lambda frontends
   1. https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-using-invoke.html
1. Look at moving actix/lambda images to alpine like the lambda one
   1. segfaults, probably with sqlite?
1. Split out the docker-compose.yml file
1. Rename dev to debug, copy the files in and use volumes as dev container
1. Custom github action?
1. Look at tagging images so the docker file can use local or pulled from ghcr.io
   1. How does this work with actions?
1. sqlite use with distroless
1. criterion benchmarking for data_layer vs current sqlite