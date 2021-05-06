variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
}

variable "k8s_version" {
  description = "Kubernetes version."
}

variable "eks_worker_ami_name_filter" {
  type        = string
  description = "AMI name filter to lookup the most recent EKS AMI if `image_id` is not provided"
  default     = "amazon-eks-node-*"
}

variable "vpc_id" {
  description = "The VPC the cluser should be created in"
}

variable "private_subnets" {
  description = "List of private subnet IDs"
}

variable "public_subnets" {
  description = "List of private subnet IDs"
}

# variable "private_subnet_ids" {
#   description = "List of private subnet ids"
# }

# variable "public_subnet_ids" {
#   description = "List of public subnet ids"
# }

variable "kubeconfig_path" {
  description = "Path where the config file for kubectl should be written to"
}