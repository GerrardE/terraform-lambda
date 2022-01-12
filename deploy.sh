aws s3 cp ./build/$S3_BUCKET_KEY s3://$S3_BUCKET/$S3_BUCKET_KEY
aws lambda update-function-code --function-name $F1 --s3-bucket $S3_BUCKET --s3-key $S3_BUCKET_KEY
