# TODOs

1. Move data fetching/db building out of the dev env
1. Add .gitignored artifacts dir to hold the db/binaries/zip
1. Confirm the db can be placed in the zip and read in the lambda
1. Dev env container for the lambda like the traditional server
1. Figure out workspaces? to have actix/lambda frontends and db lib used by both
1. Add scripts in bin to replace the embedded shell scripts in the Makefile
1. Add unit tests for db lib
1. Add integration tests, run same cases against actix/lambda frontends
   1. https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-using-invoke.html
1. Look at moving actix images to alpine like the lambda one