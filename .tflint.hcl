plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "google" {
  enabled    = true
  version    = "0.30.0"
  source     = "github.com/terraform-linters/tflint-ruleset-google"
  deep_check = false
}

rule "terraform_required_providers" {
  enabled = false
}

rule "terraform_required_version" {
  enabled = false
}

rule "terraform_module_pinned_source" {
  enabled = false
}
