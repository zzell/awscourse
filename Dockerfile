FROM ubuntu:latest

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN apt-get install git curl wget unzip gnupg2 lsb-release less -y

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update && apt-get install terraform

COPY .aws /root/.aws