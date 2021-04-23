# Terraform - Provision an EKS Cluster

## To deploy the AWS Load Balancer Controller to an Amazon EKS cluster

## In the following steps, replace the <example values> (including <>) with your own values.

#### Determine whether you have an existing IAM OIDC provider for your cluster.

#### View your cluster's OIDC provider URL.

``` 
aws eks describe-cluster --name <cluster_name> --query "cluster.identity.oidc.issuer" --output text
```

### List the IAM OIDC providers in your account. Replace <EXAMPLED539D4633E53DE1B716D3041E> (including <>) with the value returned from the previous command.
``` aws iam list-open-id-connect-providers | grep <EXAMPLED539D4633E53DE1B716D3041E> ```
### Create an IAM policy using the policy downloaded in the previous step.

``` aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json ```

### Create an IAM role and annotate the Kubernetes service account named aws-load-balancer-controller in the kube-system namespace for the AWS Load Balancer Controller using eksctl or the AWS Management Console and kubectl.
```
Using the AWS Management Console and kubectl

Open the IAM console at https://console.aws.amazon.com/iam/.

In the navigation panel, choose Roles, Create Role.

In the Select type of trusted entity section, choose Web identity.

In the Choose a web identity provider section:

For Identity provider, choose the URL for your cluster.

For Audience, choose sts.amazonaws.com.

Choose Next: Permissions.

In the Attach Policy section, select the AWSLoadBalancerControllerIAMPolicy policy that you created in step 3 to use for your service account.

Choose Next: Tags.

On the Add tags (optional) screen, you can add tags for the account. Choose Next: Review.

For Role Name, enter a name for your role, such as AmazonEKSLoadBalancerControllerRole, and then choose Create Role.

After the role is created, choose the role in the console to open it for editing.

Choose the Trust relationships tab, and then choose Edit trust relationship.

Find the line that looks similar to the following:

"oidc.eks.us-west-2.amazonaws.com/id/EXAMPLED539D4633E53DE1B716D3041E:aud": "sts.amazonaws.com"
Change the line to look like the following line. Replace <EXAMPLED539D4633E53DE1B716D3041E> (including <>) with your cluster's OIDC provider ID and replace <region-code> with the Region code that your cluster is in.

"oidc.eks.<region-code>.amazonaws.com/id/<EXAMPLED539D4633E53DE1B716D3041E>:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
Choose Update Trust Policy to finish.

Note the ARN of the role for use in a later step.

Save the following contents to a file named aws-load-balancer-controller-service-account.yaml.

apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
      eks.amazonaws.com/role-arn: arn:aws:iam::<AWS_ACCOUNT_ID>:role/AmazonEKSLoadBalancerControllerRole
Create the service account on your cluster.

kubectl apply -f aws-load-balancer-controller-service-account.yaml 
```

### Install the AWS Load Balancer Controller using Helm V3 or later or by applying a Kubernetes manifest.


#### Install the TargetGroupBinding custom resource definitions.
```
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
```
Add the eks-charts repository.
```
helm repo add eks https://aws.github.io/eks-charts
```
#### Install the AWS Load Balancer Controller using the command that corresponds to the Region that your cluster is in.
```
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=<cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  -n kube-system
  ```