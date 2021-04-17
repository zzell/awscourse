# send and receive message:
aws sqs send-message --queue-url=https://sqs.us-east-1.amazonaws.com/140305302039/terraform-20210417134538973200000002 --message-body="hello queue world" --region=us-east-1
aws sqs receive-message --queue-url=https://sqs.us-east-1.amazonaws.com/140305302039/terraform-20210417134538973200000002 --region=us-east-1


# publish sns message
aws sns publish --topic-arn=arn:aws:sns:us-east-1:140305302039:email-notification --message="yo dog" --region=us-east-1
