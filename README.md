# terraform-lambda

[![CircleCI](https://circleci.com/gh/GerrardE/terraform-lambda/tree/main.svg?style=svg)](https://circleci.com/gh/GerrardE/terraform-lambda/tree/main)

- create a source project for github repo source
- create an s3 bucket for the lambda function
- create a codebuild project that zips the lambda and sends to the s3 bucket
- create a codepipeline project that uses the codebuild project to:
   - install dependencies
   - run tests
   - build and package artifacts
   - send artifacts to s3 bucket
- create a lambda function with reference to the zipped artifact in the s3 bucket
- create 2 api gateways for the lambda functions: get & post
