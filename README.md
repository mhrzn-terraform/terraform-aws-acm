# AWS ACM Terraform module

Terraform module which ACM certificates on AWS.

## Available Features

- ACM Certificates
- Wildcard certificate
- SNI

## Usage
### Create wildcard certficate for example.com domain
```
module "service" {
  source                      = "mhrzn-terraform/acm/aws"
  version                     = "1.0.0"
  hostname                    = "example.com"
  enable_wildcard_certificate = true
  subject_alternative_names   = null
}
```
### Create certificate for example.com with SNI
```
module "service" {
  source                      = "mhrzn-terraform/acm/aws"
  version                     = "1.0.0"
  hostname                    = "example.com"
  enable_wildcard_certificate = false
  subject_alternative_names   = ["a.example.com", "b.example.com"]
}