# Tanzu CLI Github Action

## Prerequisites

* [Docker](https://docs.docker.com/desktop/)
  * A [subscription](https://www.docker.com/blog/updating-product-subscriptions/) is required for business use.
* An account on the [VMware Marketplace](https://marketplace.cloud.vmware.com/)


## Building

Consult the [Dockerfile](Dockerfile).

To build a portable container image, execute

```bash
docker build -t clicktruck/tanzu-cli-setup-action .
```


## Launching

Execute

```bash
docker run --rm -it \
  -e TANZU_CLI_ENABLED=true \
  -e AWS_ACCESS_KEY_ID={aws-access-key-id} -e AWS_SECRET_ACCESS_KEY={aws-secret-access-key} -e AWS_SESSION_TOKEN={aws-session-token} \
  -v "/var/run/docker.sock:/var/run/docker.sock:rw" \
  clicktruck/tanzu-cli-setup-action "{command}" {base64-encoded-kubeconfig-contents}
```
> Replace `{command}` and `{base64-encoded-kubeconfig-contents}` as well; should be self-evident what to supply.


## Example usage

Dispatch

```yaml
name: "test-dispatch-tanzu-cli"

on:
  workflow_dispatch:
    inputs:
      command:
        description: "The tanzu CLI command to execute"
        required: true
        default: "tanzu version"
      kubeconfig-contents:
        description: "The base64 encoded contents of a .kube/config file that already has the current Kubernetes cluster context set"
        required: true

jobs:
  tanzu-cli:
    uses: ./.github/workflows/test-tanzu-cli.yml
    with:
      command: ${{ github.event.inputs.command }}
    secrets:
      KUBECONFIG_CONTENTS: ${{ github.event.inputs.kubeconfig-contents }}
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_SESSION_TOKEN: ${{ secrets.AWS_SESSION_TOKEN }}
```

Call

```yaml
name: "test-administer-tanzu-cli"

on:
  workflow_call:
    inputs:
      command:
        description: "The tanzu CLI command to execute"
        required: true
        type: string
    secrets:
      KUBECONFIG_CONTENTS:
        required: true
      AWS_ACCESS_KEY_ID:
        required: true
      AWS_SECRET_ACCESS_KEY:
        required: true
      AWS_SESSION_TOKEN:
        required: false

jobs:
  run:
    runs-on: ubuntu-22.04

    steps:
    # Checkout the repository to the GitHub Actions runner
    - name: Checkout
      uses: actions/checkout@v4

    # Execute a command with the tanzu CLI
    - name: Execute Tanzu CLI
      uses: ./docker/actions/aws/tanzu-cli-setup-action
      with:
        command: ${{ inputs.command }}
        kubeconfig-contents: $ {{ secrets.KUBECONFIG_CONTENTS }}
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-session-token: ${{ secrets.AWS_SESSION_TOKEN }}
```

## Credits

* [Creating a Docker container action](https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action)
* [Custom GitHub Actions with Docker](https://dev.to/sethetter/custom-github-actions-with-docker-3ik3)
* [How can I install Docker inside an Alpine container](https://stackoverflow.com/questions/54099218/how-can-i-install-docker-inside-an-alpine-container)
* [How to pass arguments to Shell Script through docker run](https://stackoverflow.com/questions/32727594/how-to-pass-arguments-to-shell-script-through-docker-run)