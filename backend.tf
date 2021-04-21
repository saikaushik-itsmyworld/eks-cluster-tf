terraform {
   backend "s3" {
        bucket = "eks-infra"
        key = "state/eks-cluster"
        region = "us-east-1"
        encrypt = "true"
        workspace_key_prefix = "terraform"
    }
}