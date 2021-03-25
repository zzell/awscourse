INFRA=docker run --rm -it -v ${PWD}:/root/terraform -w /root/terraform aws-terraform-infra
BUCKET_NAME="awscourse-03-2021"

# versioning disabled for simplicity, versioning example might be found at awscourse/s3/init-s3.sh
.SILENT: init-s3
init-s3:
	# create text file
	touch hello.txt
	echo "Hello terraform world!" > hello.txt

	# create s3 bucket
	$(INFRA) aws s3api create-bucket --bucket $(BUCKET_NAME) --region us-east-1

	# upload file into bucket
	$(INFRA) aws s3 cp /root/terraform/hello.txt s3://$(BUCKET_NAME)

delete-s3:
	$(INFRA) aws s3api delete-bucket --bucket $(BUCKET_NAME)

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

ssh:
	ssh -i ${PWD}/../.aws/awscourse.pem ec2-user@$(ip)
