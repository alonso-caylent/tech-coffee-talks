# aws-community-day-mx-eks-blueprints


### Executing Steps

1. Update aws credentials account (Getting the credentials from the landing page). 
```shell
vi ~/.aws/credentials
```
Configure the credentials:
```shell
[default]
region=us-east-2
aws_access_key_id=<replace>
aws_secret_access_key=<replace>
aws_session_token=<replace>
```

2. Set the default AWS profile by assinging the following environment variable:

```shell
export AWS_PROFILE=default
```

3. Update the local tags with your info (e.g. Project and Caylent:Owner):
```shell
cd terragrunt/live/non-prod/us-east-2/dev
```
```shell
vi env.hcl
```

4. Set the S3 Bucket prefix environment variable:
```shell
export TG_BUCKET_PREFIX=<some_prefix_of_your_choice>
```

5. Switch to the newtwork live directory.
```shell
cd terragrunt/live/non-prod/us-east-2/dev/network/
```
```shell
terragrunt init
```
```shell
terragrunt plan
```
```shell
terragrunt apply
```

6. Switch to the eks live directory.
```shell
cd terragrunt/live/non-prod/us-east-2/dev/eks/
```
```shell
terragrunt init
```
```shell
terragrunt plan
```
```shell
terragrunt apply
```

7. Switch to the eks-blueprints live directory.
```shell
cd terragrunt/live/non-prod/us-east-2/dev/eks-blueprints/
```
```shell
terragrunt init
```
```shell
terragrunt plan
```
```shell
terragrunt apply
```

8. S3 app
```shell
export LB_URL=$(kubectl get svc -n s3-app-ns s3-app-svc -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
```

```shell
curl http://$LB_URL/list-buckets
```

8. Secret pod
```shell
kubectl exec -it -n dev secretmgr-app-pod -- aws secretsmanager get-secret-value --secret-id dev-secret --region us-east-1 --query 'SecretString'
```

```shell
kubectl exec -it -n qa secretmgr-app-pod -- aws secretsmanager get-secret-value --secret-id qa-secret --region us-east-1 --query 'SecretString'
```

```shell
kubectl exec -it -n dev secretmgr-app-pod -- aws secretsmanager get-secret-value --secret-id qa-secret --region us-east-1 --query 'SecretString'
```

```shell
kubectl exec -it -n qa secretmgr-app-pod -- aws secretsmanager get-secret-value --secret-id dev-secret --region us-east-1 --query 'SecretString'
```