terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.2.1"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "hextris" {
  name       = "hextris-cluster"
  node_image = "kindest/node:v1.29.0"
}