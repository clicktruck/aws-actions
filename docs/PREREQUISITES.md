# aws-actions » prerequisites

* [Increase AWS Quotas](#increase-aws-quotas)
* [(Optional) Setup an AWS service principal](#optional-setup-an-aws-service-principal)
* [(Optional) Setup a Github SSH key-pair](#optional-setup-a-github-ssh-key-pair)
* [Setup a Personal Access Token in Github](#setup-a-personal-access-token-in-github)
* [Configure Github Secrets](#configure-github-secrets)


## Increase AWS Quotas

There are a few AWS default quotas that will need to be adjusted.

1. EC2 instance quota - In the AWS portal, visit the Support Center and [create a case](https://console.aws.amazon.com/support/home?#/case/create?issueType=service-limit-increase&limitType=service-code-ec2-instances). Choose the region, primary instance type, and set the limit to >= 25 in your request.
2. Elastic IP Addresses - In the AWS portal, visit the Support Center and [create a case](https://console.aws.amazon.com/support/home?#/case/create?issueType=service-limit-increase&limitType=service-code-elastic-ips). Choose the region and set the limit to >= 30 in your request.

> Note:  The above quotas will be enough to deploy the infrastructure needed for installing TAP.  Individual mileage may vary depending on existing resources.

## (Optional) Setup an AWS service principal

First, configure AWS authentication.

> Do this only if you are planning on running Terraform scripts locally with an IAM user (i.e., you're not using AWS Session Token Service).

```bash
aws configure
```

Or set the necessary environment variables.

```bash
export AWS_ACCESS_KEY_ID=<your_root_access_key_id>
export AWS_SECRET_ACCESS_KEY=<your_root_secret_access_key>
export AWS_REGION=<region_cloud_resources_will_be_provisioned_and_accessed>
```

Next, set the following environment variables for your service account.

```bash
export AWS_SERVICE_ACCOUNT_NAME=<your_service_account_name>
export AWS_SERVICE_ACCOUNT_PASSWORD=<your_service_account_password>
```

Then, run the following script found [here](https://github.com/clicktruck/scripts/blob/main/aws/create-aws-service-account.sh).

```bash
cd /tmp
gh repo clone clicktruck/scripts
./scripts/aws/create-aws-service-account.sh
```
> Record the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` of the new service account.  These are the credentials you should use going forward with Terraform modules.


## (Optional) Setup a Github SSH key-pair

You will need to create a new public/private SSH key-pair in order to work with (i.e., pull from/push to) private git repositories (e.g., Github, Gitlab, Azure Devops).

Here's how to set up such a key-pair for named repo providers:

* [Github](https://docs.github.com/en/developers/overview/managing-deploy-keys)

Also see [Git Authentication](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.9/tap/scc-git-auth.html).


## Setup a Personal Access Token in Github

A PAT is required so that workflows can add secrets to the repository in order to be used in downstream jobs.  Documentation can be found [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

> We are using this personal access token to create secrets for the `aws` backend for Terraform


## Configure Github Secrets

Setup some Github secrets with the service principal credentials.  Documentation can be found [here](https://docs.github.com/en/actions/security-guides/encrypted-secrets).  You might also consider using [gh secret set](https://cli.github.com/manual/gh_secret_set) command to set these individually.  Or, after exporting all environment variables below, execute [gh-secrets-setup.sh](https://github.com/clicktruck/scripts/blob/main/gh-set-secrets.sh) at the command-line passing `aws` as an execution argument.

```bash
# The access key identifier associated with role-based temporary security credentials vended from AWS Security Token Service
export AWS_ACCESS_KEY_ID=
# The access key's secret associated with role-based temporary security credentials vended from AWS Security Token Service
export AWS_SECRET_ACCESS_KEY=
# An expiring session token associated with role-based temporary security credentials vended from AWS Security Token Service
export AWS_SESSION_TOKEN=
```
> Setting up a `AWS_SESSION_TOKEN` secret is optional.  However, if you have to obtain an AWS Session Token Service token (via a provider like [CloudGate](https://console.cloudgate.vmware.com/ui/#/login)) in order to authenticate to an AWS account, you will need to periodically update the `AWS_*` secret values as the token is typically set to expire.

You'll also want to [create another secret](https://github.com/clicktruck/scripts/blob/main/set-personal-access-token.sh) whose value is the fine-grained _personal access token_ you created in the prior step.

```bash
export PA_TOKEN=
```
