module "service" {
  source                      = "../../"
  hostname                    = "abc.com"
  enable_wildcard_certificate = true
  subject_alternative_names   = null
}