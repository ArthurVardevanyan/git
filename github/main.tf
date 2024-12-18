terraform {
  backend "gcs" {}
}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.2.2"
    }
  }
}