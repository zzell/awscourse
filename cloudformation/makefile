DOCKER_EXECUTABLE=docker run --rm -it -v ${PWD}/../.aws:/root/.aws -v ${PWD}/ec2-stack.json:/template.json amazon/aws-cli

deploy:
	$(DOCKER_EXECUTABLE) cloudformation deploy --template-file /template.json --stack-name runner

delete:
	$(DOCKER_EXECUTABLE) cloudformation delete-stack --stack-name runner

events:
	$(DOCKER_EXECUTABLE) cloudformation describe-stack-events --stack-name runner

# make ssh ip=54.163.81.156 where ip is public ip of ec2 instance
ssh:
	ssh -i ${PWD}/../.aws/awscourse.pem ec2-user@$(ip)