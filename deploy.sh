aws s3 sync ./build/terraform-lambda.zip s3://$S3-BUCKET/$S3-BUCKET-KEY --delete
aws lambda update-function-code --function-name $F1 --s3-bucket $S3-BUCKET --s3-key $S3-BUCKET-KEY
aws lambda update-function-code --function-name $F2 --s3-bucket $S3-BUCKET --s3-key $S3-BUCKET-KEY
