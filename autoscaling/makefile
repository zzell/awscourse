CLI=docker run --rm -it -v ${PWD}/../.aws:/root/.aws -v ${PWD}/asg-stack.yaml:/template.yaml amazon/aws-cli

deploy:
	$(CLI) cloudformation deploy --template-file /template.yaml --stack-name rungroup

delete:
	$(CLI) cloudformation delete-stack --stack-name rungroup

events:
	$(CLI) cloudformation describe-stack-events --stack-name rungroup

# make ssh ip=54.163.81.156 where ip is public ip of ec2 instance
ssh:
	ssh -i ${PWD}/../.aws/awscourse.pem ec2-user@$(ip)