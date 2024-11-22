# Object Store

Generic module for creating object storage resources.

Concretely, this Terraform module provisions an AWS S3 bucket with customizable naming and tagging options. It's designed for easy creation and management of S3 buckets within AWS, supporting custom configurations through variables.

## Usage

To use this module in your Terraform configuration, include something like the following:

```hcl
module "s3_bucket" {
  source      = "../../modules/object-store"

  bucket_name = "my-unique-bucket-name"
  tags = {
    environment = "production"
    service     = "my-service"
    team        = "my-team"
  }
}
```

### Requirements

- Terraform 0.12.x and above
- AWS Provider plugin

Ensure your AWS credentials are configured correctly, either through the AWS CLI, environment variables, or other Terraform authentication mechanisms.

## Considerations

- Bucket names are globally unique. If the specified bucket name is already taken, Terraform will return an error during the apply phase.
- This module does not currently support advanced bucket configurations (like versioning, logging, etc.). For more complex configurations, consider extending the module or managing additional settings outside this module.

For more information on AWS S3 and bucket configuration options, visit the [AWS S3 Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket).
