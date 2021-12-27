ls -a
aws s3 sync build/terraform-lambda.zip s3://$S3_BUCKET/$S3_BUCKET_KEY --delete
aws lambda update-function-code --function-name $F1 --s3-bucket $S3_BUCKET --s3-key $S3_BUCKET_KEY
aws lambda update-function-code --function-name $F2 --s3-bucket $S3_BUCKET --s3-key $S3_BUCKET_KEY
