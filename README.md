# Terraform Modules

> [!WARNING]
> This is a work in progress. It has not been tested in a production environment.

## Setup

We'll be spinning up resources locally with [Docker Compose](https://docs.docker.com/compose/install/). Our Brewfile will ensure that all client CLIs are installed.

```sh
brew bundle
```

## Usage

Each [module](./modules) has its own README with specific usage instructions. The important thing to note is that each module is designed to be used independently, but can be combined to create more complex infrastructure. Namely, the `composite` module is a collection of other modules that work together to create a more complex infrastructure. See [public-cluster](./modules/composite/public-cluster) for an example.

### terraform CLI

```sh
docker compose up -d
```

To use our local version of AWS ([localstack](https://github.com/localstack/localstack)), we'll need to set some env

```sh
export AWS_ACCESS_KEY_ID=mock_access_key
export AWS_SECRET_ACCESS_KEY=mock_secret_key
```

If we want to use Vault, we'll need to set some env

```sh
export VAULT_ADDR='http://localhost:8200'
export VAULT_TOKEN="root"
```

Then we can run our Terraform commands, after creating a bucket for our state

```sh
aws --endpoint-url=http://localhost:4566 s3 mb s3://my-terraform-state

terraform init
terraform plan
terraform apply

terraform output

terraform destroy
```
