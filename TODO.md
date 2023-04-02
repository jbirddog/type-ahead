# TODOs

1. Confirm the db can be placed in the zip and read in the lambda
1. Dev env container for the lambda like the traditional server
1. Add zip to the lambda release Dockerfile, remove from Makefile
1. Figure out workspaces? to have actix/lambda frontends and db lib used by both
1. Replace the embedded shell scripts in the Makefile with the trick used to get the db
1. Add unit tests for db lib
1. Add integration tests, run same cases against actix/lambda frontends
   1. https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-using-invoke.html
1. Look at moving actix/lambda images to alpine like the lambda one
1. Split out the docker-compose.yml file
1. Create a job to build the data container, use it as a build stage in dev/release
1. Rename dev to debug, copy the files in and use volumes as dev container