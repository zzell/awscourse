# awscourse

## Prerequisites
- Docker (in `make` commands AWS CLI is running in docker container)
- Configure:
    - Create `.aws` directory in project root.
    - Put `config` and `credentials` files in `.aws`
    - Put `awscourse.pem` (private key) in `.aws`

## Cloudformation
1. ```cd cloudformation && make deploy```
2. To SSH into newly deployed EC2: ```make ssh ip=<public ip>```