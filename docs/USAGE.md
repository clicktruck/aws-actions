# aws-actions » usage

Review this curated collection of dispatch workflows.

## Prerequisites

When [external-dns](https://kubernetes-sigs.github.io/external-dns) is installed in a target [cluster](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html) as part of [application-templates/tanzu/aws/ingress](https://github.com/clicktruck/application-templates/tree/main/tanzu/ingress/aws), [static credentials](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md#static-credentials) are employed.  This install method does not allow for [STS temporary credentials](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp.html); therefore, you'll need to maintain a separate AWS account with an IAM [user account](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md#create-iam-user-and-attach-the-policy), [policy](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md#iam-policyy) and [DNS zones](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html).

So, after creating the user account and attaching the policy, you will need to set two [Github Action secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository):

* `ROUTE53_ZONE_AWS_ACCESS_KEY_ID`
* `ROUTE53_ZONE_AWS_SECRET_ACCESS_KEY`

Setup a couple of environment variables of the same name, then use the [gh-set-secrets.sh](https://github.com/clicktruck/scripts/blob/main/gh-set-secrets.sh) script with the `--include-route53-static-credentials` option to do that.

Likewise, when creating the DNS zones (using the dispatch workflows above), make sure you are entering those same credentials as inputs. You'll need to do this before attempting to create a cluster or workshop environment.

## Guides

### Quick

Take this path when you want to get up-and-running as quickly as possible with the least amount of fuss.

| Action | Link |
| :---   | :---: |
| _Create workflows_ | Choose `create` before clicking on the `Run workflow` button |
| KMS Key | [:white_check_mark:](../../../actions/workflows/aws-kms-dispatch.yml) |
| Remote Backend Support | [:white_check_mark:](../../../actions/workflows/aws-provided-remote-backend-dispatch.yml) |
| Toolset image | [:white_check_mark:](../../../actions/workflows/aws-ubuntu-22_04.yml) |
| If the job completes successfully, you will need to look up the `Owner account ID`.  You could do that by visiting the following URL in your favorite browser. `https://{AWS_REGION}.console.aws.amazon.com/ec2/v2/home?region={AWS_REGION}#Images:` where you would replace occurrences of `{AWS_REGION}` above with the value you configured earlier as a Github Secret employed by the Github Action.  You will see a listing of all AMIs that you have permissions to view.  Look for an AMI starting with the name you defined in the job inputs.  Click on the AMI id hyperlink, then record the Owner account ID as you will need it in later steps. | |
| DNS Zone for base domain | [:white_check_mark:](../../../actions/workflows/aws-main-dns-dispatch.yml) |
| DNS Zone for sub domain | [:white_check_mark:](../../../actions/workflows/aws-child-dns-dispatch.yml) |
| Create workshop environment | [:white_check_mark:](../../../actions/workflows/aws-e2e.yml) |
| _Cleanup workflows_ | Choose `destroy` before clicking on the `Run workflow` button |
| Destroy workshop environment | [:white_check_mark:](../../../actions/workflows/aws-e2e-destroy.yml) |
| DNS Zone for sub domain | [:white_check_mark:](../../../actions/workflows/aws-child-dns-dispatch.yml) |
| DNS Zone for base domain | [:white_check_mark:](../../../actions/workflows/aws-main-dns-dispatch.yml) |
| Remote Backend Support | [:white_check_mark:](../../../actions/workflows/aws-provided-remote-backend-dispatch.yml) |
| KMS Key | [:white_check_mark:](../../../actions/workflows/aws-kms-dispatch.yml) |
| Clean Workflow Logs | [:white_check_mark:](../../../actions/workflows/clean-workflow-run-logs.yml) |


### Deliberate

Administer resources one at a time.

There are two types of actions defined, those that can be manually triggered (i.e., dispatched), and those that can only be called by another action.  All actions are located [here](../../../actions) and can be run by providing the required parameters.  Go [here](../../.github/workflows) to inspect the source for each action.

> Note that for most dispatch actions, you have the option to either create or destroy the resources.

#### Modules

| Module       | Github Action       | Terraform             |
| :---       | :---:               | :---:                   |
| IAM Roles  | [:white_check_mark:](../../../actions/workflows/iam-roles-disaptch.yml) | |
| KMS |[:white_check_mark:](../../../actions/workflows/aws-kms-dispatch.yml) | [:white_check_mark:](https://github.com/clicktruck/aws-terraform/tree/main/modules/kms) |
| Remote backend | [:white_check_mark:](../../../actions/workflows/aws-provided-remote-backend-dispatch.yml) | [:white_check_mark:](https://github.com/clicktruck/aws-terraform/tree/main/modules/tfstate-support) |
| Keypair | [:white_check_mark:](../../../actions/workflows/aws-keypair-dispatch.yml) | [:white_check_mark:](../terraform/azure/keypair) |
| VPC | [:white_check_mark:](../../../actions/workflows/aws-virtual-network-dispatch.yml) | [:white_check_mark:](https://github.com/clicktruck/aws-terraform/tree/main/modules/virtual-network) |
| DNS Zone for base domain | [:white_check_mark:](../../../actions/workflows/aws-main-dns-dispatch.yml) | [:white_check_mark:](https://github.com/clicktruck/aws-terraform/tree/main/modules/main-dns) |
| DNS Zone for sub domain | [:white_check_mark:](../../../actions/workflows/aws-child-dns-dispatch.yml) | [:white_check_mark:](https://github.com/clicktruck/aws-terraform/tree/main/modules/child-dns) |
| EKS Cluster | [:white_check_mark:](../../../actions/workflows/aws-k8s-cluster-dispatch.yml) | [:white_check_mark:](https://github.com/clicktruck/aws-terraform/tree/main/modules/cluster) |
| EKS Cluster Addons |  | [:white_check_mark:](https://github.com/clicktruck/aws-terraform/tree/main/modules/cluster-addons) |
| EKS Cluster Storage Updates |  | [:white_check_mark:](https://github.com/clicktruck/aws-terraform/tree/main/modules/cluster-storage) |
| Container registry | [:white_check_mark:](../../../actions/workflows/aws-container-registry-dispatch.yml) | [:white_check_mark:](https://github.com/clicktruck/aws-terraform/tree/main/modules/registry) |
| Harbor | [:white_check_mark:](../../../actions/workflows/aws-harbor-dispatch.yml) | [:white_check_mark:](../terraform/k8s/harbor) |
| Bastion | [:white_check_mark:](../../../actions/workflows/aws-bastion-dispatch.yml) | [:white_check_mark:](https://github.com/clicktruck/aws-terraform/tree/main/modules/bastion) |
| Secrets Manager | [:white_check_mark:](../../../actions/workflows/aws-secrets-manager-dispatch.yml) | [:white_check_mark:](https://github.com/clicktruck/aws-terraform/tree/main/modules/secrets-manager) |
| Secrets | [:white_check_mark:](../../../actions/workflows/aws-secrets-manager-secrets-dispatch.yml) | [:white_check_mark:](https://github.com/clicktruck/aws-terraform/tree/main/modules/secrets-manager-secrets) |


## Accessing credentials

All credentials are stored in AWS Secrets Manager.

There is only one credential that needs to be pulled down to get started, all other credentials will be accessible from the bastion host. This credential is the private SSH key for the bastion host.

First, configure AWS using the service account credentials you created earlier or ask for temporary security credentials from the secure token service.

```bash
aws secretsmanager get-secret-value --secret-id {SECRETS_MANAGER_ARN}
```
> Replace the `{SECRETS_MANAGER_ARN}` with the ARN of the secrets manager instance.  A response in JSON-format will contain all the credentials you need to connect to the bastion host, cluster and container registry.

Refer to [Tutorial: Create and retrieve a secret](https://docs.aws.amazon.com/secretsmanager/latest/userguide/tutorials_basic.html#tutorial-basic-step2) for an example.
