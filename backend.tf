terraform {
   backend "s3" {
        bucket = "eks-infra-mcx"
        key = "state/eks-cluster"
        region = "us-west-2"
        encrypt = "true"
        workspace_key_prefix = "terraform"
    }
}