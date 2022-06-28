# Overview and Thoughts
To enable a fast deployment process, AWS resources will be provisioned using Terraform .  The archicture  compoent to support  resiliency, reliability, scalability, security, load balancing are stated below;
- Public Subnet ( internet facing , Load Balncer is provisioned in this subnet ) 
- Private Subnet.
- Route tables
- Security group 
- Intenet gateway
- Nat Gateway
- Ec2 Instances
- S3 Bucket ( remote state file )
- DynamoDB lock


# How to use ths project

## Prequisite 
- Terraform installed
- AWS CLI configured



### STEP 1: Initiate terrform
- cd to Project 
- terrform init

### STEP 2: Create Resources 
- terraform plan 
- terrfaorm apply --auto-approve



