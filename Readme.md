# Terraform/Terraform confluent provider tutorial
## Simple Docker example
**Commands :**
```sh
cd terraform-docker
terraform plan # optional- to preview provisioning
terraform apply # apply the plan and provision nginx image and container
terraform state show docker_container.nginx
```
**References :**
https://learn.hashicorp.com/tutorials/terraform/docker-build?in=terraform/docker-get-started 
https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image
https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container
## AWS provider simple example
**Commands :**
```sh
cd terraform-aws
export TF_VAR_region_name=<<your_aws_region_name>>
export TF_VAR_key_name=<<your_ec2_key_pair_name>>
terraform plan # optional- to preview provisioning
terraform apply --auto_approve=true # apply the plan and provision nginx image and container
terraform state show aws_instance.app_server
terraform output url # outputs the "url" output variable
```
**References :**
https://registry.terraform.io/providers/hashicorp/aws/4.26.0/docs/resources/instance
 https://registry.terraform.io/providers/hashicorp/aws/4.26.0/docs/data-sources/key_pair
https://registry.terraform.io/providers/hashicorp/aws/4.26.0/docs/data-sources/vpc
Terraform providers : https://www.terraform.io/language/providers
Terraform data sources : https://www.terraform.io/language/data-sources
Terraform resources : https://www.terraform.io/language/resources 
## Confluent cloud provider simple example
Same instructions as these https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/guides/sample-project
The only change made here is that I added  "confluent_environment" datasource referenced by the string variable "environment" representing the **name** of the confluent cloud environment.
You'll have to provide a value for the variable (by exporting the env variable for example : export TF_VAR_environment=aws or via -var environment=aws option when you apply)
In this example a basic CC cluster is created, the topic "orders", 3 service accounts are provisionned;
- "app-manager"  Service account to manage 'gna-inventory' Kafka cluster.It is required in this configuration to create 'orders' topic and grant ACLs to 'app-producer' and 'app-consumer' service accounts.
- "app-consumer" Service account to consume from 'orders' topic of 'gna-inventory' Kafka cluster
- "app-producer" Service account to produce to 'orders' topic of 'gna-inventory' Kafka cluster

Confluent cloud Role binding "CloudClusterAdmin" granted to "app-manager" and app-manager-kafka-api-key 
API keys for "app-consumer" and "app-producer" clients and respectively READ and WRITE ACLs to them.
The consumer READ ACL provionned by this tf template is exclusive to Confluent CLI consumer ;

> "The existing values of resource_name, pattern_type attributes are set up to match Confluent > CLI's default consumer group ID ("confluent_cli_consumer_<uuid>").
> https://docs.confluent.io/confluent-cli/current/command-reference/kafka/topic/confluent_kafka_t opic_consume.html
> Update the values of resource_name, pattern_type attributes to match your target consumer group ID.
> https://docs.confluent.io/platform/current/kafka/authorization.html#prefixed-acls"