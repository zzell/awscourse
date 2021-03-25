# awscourse

## Prerequisites
- Docker
- Configure:
    - Create `.aws/` directory in project root.
    - Put `config` and `credentials` files in `.aws/`
    - Put `awscourse.pem` (private key) in `.aws/`

## Cloudformation, autoscaling, s3
1. ```cd cloudformation && make deploy```
2. To SSH into newly deployed EC2: ```make ssh ip=<public ip>```

## Terraform
1. In root dir: `make build container`
2. `cd terraform && make init-s3`
3. `make tf-init && make tf-apply`

#### Terraform cleanup
```
make delete-s3
make tf-destroy
```