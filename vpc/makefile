INFRA=docker run --rm -it -v ${PWD}:/root/terraform -w /root/terraform aws-terraform-infra

tf-help:
	$(INFRA) terraform help

tf-init:
	$(INFRA) terraform init

tf-plan:
	$(INFRA) terraform plan

tf-validate:
	$(INFRA) terraform validate

tf-apply:
	$(INFRA) terraform apply

tf-show:
	$(INFRA) terraform show

tf-destroy:
	$(INFRA) terraform destroy

tf-fmt:
	$(INFRA) terraform fmt

tf-get:
	$(INFRA) terraform get

scp-key:
	scp -i ${PWD}/../.aws/awscourse.pem ${PWD}/../.aws/awscourse.pem ec2-user@$(ip):/tmp/

ssh:
	ssh -i ${PWD}/../.aws/awscourse.pem ec2-user@$(ip)
