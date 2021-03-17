CLI=docker run --rm -it -v ${PWD}/../.aws:/root/.aws -v ${PWD}/ec2-stack.json:/template.json amazon/aws-cli

deploy:
	$(CLI) cloudformation deploy --template-file /template.json --stack-name runner

delete:
	$(CLI) cloudformation delete-stack --stack-name runner

events:
	$(CLI) cloudformation describe-stack-events --stack-name runner

# make ssh ip=54.163.81.156 where ip is public ip of ec2 instance
ssh:
	ssh -i ${PWD}/../.aws/awscourse.pem ec2-user@$(ip)