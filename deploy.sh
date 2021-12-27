aws s3 cp ./build/terraform-lambda.zip s3://prod-terraform-lambda-artifact-store-lwsrxw/terraform-lambda.zip
aws lambda update-function-code --function-name $F1 --s3-bucket prod-terraform-lambda-artifact-store-lwsrxw --s3-key terraform-lambda.zip
aws lambda update-function-code --function-name $F2 --s3-bucket prod-terraform-lambda-artifact-store-lwsrxw --s3-key terraform-lambda.zip
