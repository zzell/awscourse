CLI=docker run --rm -it -v ${PWD}/../.aws:/root/.aws -v ${PWD}/s3-stack.yaml:/template.yaml amazon/aws-cli
BUCKET_NAME=awscourse-03-2021

# TODO: fix delete script. For now run "make list-versions" and paste the output instead of <list>
# docker run --rm -it -v ${PWD}/../.aws:/root/.aws amazon/aws-cli s3api delete-objects --bucket awscourse-03-2021 --delete <list>

list-versions:
	$(CLI) s3api list-object-versions \
		--bucket $(BUCKET_NAME) \
		--output=json \
		--query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}'

delete-bucket:
	$(CLI) s3api delete-bucket --bucket $(BUCKET_NAME)

deploy:
	$(CLI) cloudformation deploy --template-file /template.yaml --stack-name s3stack --capabilities CAPABILITY_IAM

delete:
	$(CLI) cloudformation delete-stack --stack-name s3stack

events:
	$(CLI) cloudformation describe-stack-events --stack-name s3stack

# make ssh ip=54.163.81.156 where ip is public ip of ec2 instance
ssh:
	ssh -i ${PWD}/../.aws/awscourse.pem ec2-user@$(ip)
